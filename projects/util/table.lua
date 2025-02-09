--- A simple utility for creating a deep copy of a table
--- Does not preserve metatables and cannot handle recursive properties
local function copyDeep(t)
	local result = {}
	for key, value in pairs(t) do
		if type(value) == "table" then
			result[key] = copyDeep(value)
		else
			result[key] = value
		end
	end
	return result
end

return {
	copyDeep = copyDeep
}
