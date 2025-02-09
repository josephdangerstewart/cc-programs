local listUtil = require("util.list")

local Classy = {}

--[[ Extends a class ]]
function Classy:extend(staticProperties)
	local resultingClass = {
		__classy = {
			kind = "class",
			super = self,
			classChain = (self.__classy and self.__classy.classChain) or {Classy},
		}
	}

	table.insert(resultingClass.__classy.classChain, resultingClass)

	setmetatable(resultingClass, {
		__index = self
	})

	if type(staticProperties) == "table" then
		for key in pairs(staticProperties) do
			resultingClass[key] = staticProperties[key]
		end
	end

	function resultingClass:init(...)
		self.super:init(...)
	end

	return resultingClass
end

local function makeSuper(instance, class)
	assert(instance.__classy and instance.__classy.kind == "instance", "Invalid instance")
	assert(class.__classy and class.__classy.kind == "class", "Invalid class")
	assert(class.__classy.super, "cannot make super for class with no super class")

	local super = {}
	setmetatable(super, {
		__index = function(tab, key)
			local superClass = class.__classy.super

			-- If the requested key is a method that is
			-- implemented on the super class, return that
			if type(superClass[key]) == "function" then
				return superClass[key]
			end

			-- Allow for multiple inheritence, but use the
			-- one instance for property
			if key == "super" then
				return makeSuper(instance, superClass)
			end

			return instance[key]
		end,
		__newindex = function(tab, key, value)
			rawset(instance, key, value)
		end
	})

	return super
end

local function getIndexedProperty(instance, class, key)
	if not rawget(instance, "__classy").isFullyConstructed then
		return nil
	end

	local currentClass = class
	if Classy[key] then
		return nil
	end

	local safeInstance = {}
	setmetatable(safeInstance, {
		__index = function(subTab, subKey)
			local rawGetResult = rawget(instance, subKey)
			if rawGetResult ~= nil then
				return rawGetResult
			end
			return class[subKey]
		end
	})

	while currentClass and currentClass.__classy do
		local indexer = currentClass.__index
		if indexer then
			local indexerResult = indexer(safeInstance, key)
			if indexerResult ~= nil then
				return indexerResult
			end
		end

		currentClass = currentClass.__classy.super
	end
end

function Classy:isType(class)
	assert((class.__classy and class.__classy.kind == "class") or class == Classy, "class must be a Classy class")

	if self.__classy.kind == "instance" then
		return listUtil.indexOf(self.__classy.classChain, self.__classy.class) >= listUtil.indexOf(self.__classy.classChain, class)
	else
		return listUtil.indexOf(self.__classy.classChain, self) >= listUtil.indexOf(self.__classy.classChain, class)
	end
end

function Classy:assertIsType(class)
	assert(self:isType(class), "invalid class")
end

function Classy:new(...)
	assert(self.__classy ~= nil, "attempted to instantiate non-class")

	local instance = {
		__classy = {
			kind = "instance",
			isFullyConstructed = false,
			baseinitCalls = 0,
			class = self,
			classChain = self.__classy.classChain,
		}
	}

	instance.super = makeSuper(instance, self)

	local _self = self
	setmetatable(instance, {
		__index = function(tab, key)
			if _self[key] then
				return _self[key]
			end

			local indexedProperty = getIndexedProperty(instance, _self, key)
			if indexedProperty ~= nil then
				return indexedProperty
			end
		end
	})

	instance:init(...)
	assert(instance.__classy.baseinitCalls == 1, "Failed to fully construct instance, make sure to call self.super:init()")
	instance.__classy.isFullyConstructed = true

	return instance
end

function Classy:init()
	assert(self.__classy ~= nil, "Invalid init call")
	assert(self.__classy.kind == "instance", "Attempted to construct non instance")
	assert(self.__classy.isFullyConstructed == false, "Attempted to construct already constructed instance")
	assert(self.__classy.baseinitCalls == 0, "Attempted to call init twice")
	self.__classy.baseinitCalls = self.__classy.baseinitCalls + 1
end

function Classy:initProperties(properties)
	assert(self.__classy ~= nil, "Invalid initProperties call")
	assert(self.__classy.kind == "instance", "Attempted to init properties on non instance")
	assert(self.__classy.isFullyConstructed == false, "Attempted to init properties on unconstructed instance")

	for key, value in pairs(properties) do
		assert(key ~= "__classy" and key ~= "super", "Attempted to init invalid property: " .. key)
		self[key] = value
	end
end

return Classy
