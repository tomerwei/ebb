
import "compiler.liszt"
require "tests/test"

local cells = L.NewRelation(10, 'cells')
local particles = L.NewRelation(10, 'particles')

cells:NewField('temperature', L.double):Load(0.0)
particles:NewField('cell', cells):Load(function (id) return id end)
particles:NewField('pos', L.vec3d):Load({0, 1, 2})


-----------------------------------
-- Type Checking / Phase Checking
-----------------------------------

-- cannot delete from a relation currently being referenced by
-- another relation
test.fail_function(function()
  -- try to delete each cell
  liszt kernel( c : cells )
    delete c
  end
end, "Cannot delete from relation cells because%s*it\'s referred to by a field: particles.cell")

-- cannot delete indirectly
test.fail_function(function()
  liszt kernel( p : particles )
    delete p.cell
  end
end, "Only centered rows may be deleted")

-- CANNOT HAVE 2 DELETE STATEMENTS in the same kernel
test.fail_function(function()
  liszt kernel( p : particles )
    if L.id(p) % 2 == 0 then
      delete p
    else
      delete p
    end
  end
end, "Temporary: can only have one delete statement per kernel")


-----------------------------------
-- Observable Effects
-----------------------------------

-- delete half the particles
test.eq(particles:Size(), 10)

local delete_even = liszt kernel( p : particles )
  if L.id(p) % 2 == 0 then
    delete p
  else
    p.pos[0] = 3
  end
end

local post_delete_trivial = liszt kernel( p : particles )
  L.assert(p.pos[0] == 3)
end

delete_even(particles)

test.eq(particles:Size(), 5)

-- trivial kernel should not blow up
post_delete_trivial(particles)