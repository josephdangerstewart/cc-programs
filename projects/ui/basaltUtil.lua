--[[
Desired index chain: object -> frame -> controller -> result
]]

local function stringStartsWith(s, frag)
	return string.sub(s,1,string.len(frag)) == frag
end

local function stringEndsWith(s, frag)
	return string.sub(s, string.len(frag) * -1, -1) == frag
end

local function generateId()
	local result = math.random() .. "" .. os.getComputerID() .. os.clock()
	return "item" .. string.gsub(result, "%.", "")
end

local function wrapFrameWithChildrenObserver(frame, onAddObject, onRemoveObject)
	local result = {}
	setmetatable(result, {
		__index = function(tab, key)
			if stringStartsWith(key, "add") and frame[key] ~= nil then
				return function(...)
					local object = frame[key](unpack(arg))
					onAddObject(object)

					local oldRemove = object.remove

					function object:remove()
						oldRemove(object)
						onRemoveObject(self)
					end

					return object
				end
			end

			if key == "removeObject" then
				return function(self, idOrObj)
					local object = type(idOrObj) == "string" and self:getObject(idOrObj) or idOrObj

					if frame:removeObject(idOrObj) then
						onRemoveObject(object)
					end
				end
			end

			return frame[key]
		end
	})

	return result
end

local function extend(controller, ...)
	local parents = arg
	setmetatable(controller, {
		__index = function(tab, key)
			for i,parent in ipairs(parents) do
				if parent[key] ~= nil then
					return parent[key]
				end
			end
		end
	})

	return controller
end

local function disableFunctions(object, ...)
	local functions = arg
	local result = {}
	local set = {}
	local prefixes = {}

	for key in pairs(functions) do
		if stringEndsWith(key, "...") then
			table.insert(prefixes, string.sub(key, 0, -4))
		else
			set[functions[key]] = true
		end
	end

	setmetatable(result, {
		__index = function(t, key)
			if set[key] then
				return nil
			end

			if #prefixes > 0 then
				for i,prefix in ipairs(prefixes) do
					if string.startsWith(key, prefix) then
						return nil
					end
				end
			end

			return object[key]
		end
	})

	return result
end

return {
	extend = extend,
	wrapFrameWithChildrenObserver = wrapFrameWithChildrenObserver,
	disableFunctions = disableFunctions,
	generateId = generateId,
}
