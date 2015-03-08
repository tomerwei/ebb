import "compiler.liszt"
local test = require "tests/test"


local LMesh = L.require "domains.lmesh"
local mesh = LMesh.Load("examples/mesh.lmesh")

------------------
-- Should pass: --
------------------
local vk = liszt (v : mesh.vertices)
    var x = {5, 4, 3}
    v.position += x
end
mesh.vertices:map(vk)

local x_out = L.Global(L.float, 0.0)
local y_out = L.Global(L.float, 0.0)
local y_idx = L.Global(L.int, 1)
local read_out_const = liszt(v : mesh.vertices)
    x_out += L.float(v.position[0])
end
local read_out_var = liszt(v : mesh.vertices)
    y_out += L.float(v.position[y_idx])
end
mesh.vertices:map(read_out_const)
mesh.vertices:map(read_out_var)

local avgx = x_out:get() / mesh.vertices:Size()
local avgy = y_out:get() / mesh.vertices:Size()
test.fuzzy_eq(avgx, 5)
test.fuzzy_eq(avgy, 4)

------------------
-- Should fail: --
------------------
idx = 3.5
test.fail_function(function()
  local liszt t(v : mesh.vertices)
      v.position[idx] = 5
  end
  mesh.vertices:map(t)
end, "expected an integer")

