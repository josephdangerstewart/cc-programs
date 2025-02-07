local listUtil = require("util.list")

local function requireAll(...)
	return {
		matcherKind = "and",
		children = {...}
	}
end

local function requireAny(...)
	return {
		matcherKind = "or",
		children = {...}
	}
end

local function exactMatch(...)
	return {
		matcherKind = "exact",
		children = {...}
	}
end

local function requireChest(kind)
	if (kind == nil) then
		return "inventory"
	end

	return exactMatch("inventory", kind)
end


local function isMatch(peripheralTypes, matcher)
	local peripheralTypesList = type(peripheralTypes) == "table" and peripheralTypes or {peripheralTypes}

	if type(matcher) == "string" then
		listUtil.contains(peripheralTypesList, matcher)
	end

	if matcher.matcherKind == "exact" then
		local matcherSet = listUtil.toSet(matcher.children)

		for i,v in pairs(peripheralTypesList) do
			if not matcherSet[v] then
				return false
			end
		end

		return true
	end

	if matcher.matcherKind == "and" then
		for i,subMatcher in pairs(matcher.children) do
			if not isMatch(peripheralTypes, subMatcher) then
				return false
			end
		end
		return true
	end

	if matcher.matcherKind == "or" then
		for i,subMatcher in pairs(matcher.children) do
			if isMatch(peripheralTypes, subMatcher) then
				return true
			end
		end
		return false
	end

	return false
end

return {
	requireAll = requireAll,
	requireAny = requireAny,
	exactMatch = exactMatch,
	requireChest = requireChest,
	isMatch = isMatch,
}
