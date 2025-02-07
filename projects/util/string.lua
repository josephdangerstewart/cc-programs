local function startsWith(s, frag)
	return string.sub(s,1,string.len(frag)) == frag
end

local function split(s, separator)
	local result = {}
	for match in string.gmatch(s, "([^" .. separator .. "]+)") do
		table.insert(result, match)
	end
	return result
end

local function capitalize(s)
	return string.gsub(s, "^%l", string.upper, 1)
end

local function formatSnakeCase(s)
	local parts = split(s, "_")
	for i,v in ipairs(parts) do
		parts[i] = capitalize(v)
	end

	return table.concat(parts, " ")
end

return {
	startsWith = startsWith,
	split = split,
	capitalize = capitalize,
	formatSnakeCase = formatSnakeCase,
}
