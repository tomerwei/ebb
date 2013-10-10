import "compiler/liszt"
require "tests/test"

mesh   = LoadMesh("examples/mesh.lmesh")
pos    = mesh:fieldWithLabel(Vertex, Vector.type(float, 3), "position")
val    = mesh:field(Vertex, float, 1.0)

red = mesh:scalar(float, 0.0)

-- checking decl statement, if statement, proper scoping
local l = liszt_kernel (v)
	var y
	if val(v) == 1.0 then
		y = 1.0
	else
		y = 0.0
	end

	red = red + y
end

mesh.vertices:map(l)
test.eq(red:value(), mesh.vertices:size())