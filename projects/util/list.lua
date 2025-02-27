local tableUtil = require("util.table")

local function contains(t, item)
	for key in pairs(t) do
		if t[key] == item then
			return true
		end
	end
	return false
end

local function indexOf(t, item)
	for i, v in ipairs(t) do
		if v == item then
			return i
		end
	end

	return -1
end

local function map(t, mapper)
	local result = {}
	for i,v in pairs(t) do
		table.insert(result, mapper(v, i, t))
	end
	return result
end

local function combine(...)
	local result = {}
	for argIndex, argTable in ipairs({...}) do
		for i,v in pairs(argTable) do
			table.insert(result, v)
		end
	end
	return result
end

local function filter(t, shouldTakeItemCallback)
	local result = {}
	for i,v in pairs(t) do
		if shouldTakeItemCallback(v, i, t) then
			table.insert(result, v)
		end
	end
	return result
end

local function toSet(t)
	local set = {}
	for i,v in pairs(t) do
		set[v] = true
	end
	return set
end

local function find(t, findCallback)
	for i,v in pairs(t) do
		if findCallback(v) then
			return v, i
		end
	end
	return nil, -1
end

local function insertAll(t, ...)
	for i,v in pairs({...}) do
		table.insert(t, v)
	end
end

local function unique(t)
	return tableUtil.keys(toSet(t))
end

return {
	contains = contains,
	map = map,
	combine = combine,
	filter = filter,
	toSet = toSet,
	find = find,
	indexOf = indexOf,
	insertAll = insertAll,
	unique = unique
}
