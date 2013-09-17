test = {}

function test.eq(a,b)
	if a ~= b then
		error(tostring(a) .. " ~= "  .. tostring(b),2)
	end
end
function test.neq(a,b)
	if a == b then
		error(tostring(a) .. " == "  .. tostring(b),2)
	end
end

function test.meq(a,...)
	local lst = {...}
	if #lst ~= #a then
		error("size mismatch",2)
	end
	for i,e in ipairs(a) do
		if e ~= lst[i] then
			error(tostring(i) .. ": "..tostring(e) .. " ~= " .. tostring(lst[i]),2)
		end
	end
end

function test.time(fn)
    local s = os.clock()
    fn()
    local e = os.clock()
    return e - s
end

-- This code is based off tests/coverage.t from the terra project
function test.fail_function(fn, match)
	local success, msg = pcall(fn)
	if success then
		error("Function did not produce the expected failure.", 2)
	elseif not string.match(msg,match) then
		error("Function did not produce the expected error: " .. msg, 2)
	end
end

-- And this function is based off of a similar fn found in tests/twolang.t in the terra project
function test.fail_parse(str,match)
	local r,msg = terralib.loadstring(str)
	if r then
		error("Erroneous syntax did not produce error.", 2)
	elseif not msg:match(match) then
		error("Erroneous syntax did not produce the expected error: " .. msg, 2)
	end
end

return test