local Classy = require("classy.Classy")
local Database = require("data.Database")
local listUtil = require("util.list")
local tableUtil = require("util.table")
local matchers = require("periphery.peripheralMatchers")
local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")

local PeripheryNetwork = Classy:extend()

function PeripheryNetwork:init(...)
	self.super:init()

	local database = Database:new("periphery/data/virtualPeripherals")

	local peripheralTypes = {}
	for i, peripheralType in pairs({...}) do
		peripheralType:assertIsType(VirtualPeripheralBase)
		peripheralTypes[peripheralType.name] = peripheralType
	end

	self:initProperties({
		peripheralTypes = peripheralTypes,
		virtualPeripherals = {},
		database = database
	})
end

function PeripheryNetwork:get(peripheralId)
	-- If we've already constructed this peripheral, return that
	if self.virtualPeripherals[peripheralId] then
		return self.virtualPeripherals[peripheralId]
	end

	-- Otherwise, check if parameters exist for it in the database
	local dbPeripheral = self.database:get(peripheralId)
	if dbPeripheral then
		local PeripheralType = self:_resolveNameOrType(dbPeripheral.type)
		local instance = PeripheralType:new(dbPeripheral.peripherals, dbPeripheral.options, self)
		instance:setId(peripheralId)
		self.virtualPeripherals[peripheralId] = instance
		return instance
	end

	-- No such peripheral exists
	return nil
end

function PeripheryNetwork:list(typeFilter)
	local results = {}
	for id in self.database:enumerateAll() do
		local existing = self:get(id)

		if
			(not typeFilter) or
			(type(typeFilter) == "string" and existing and existing.name == typeFilter) or
			(existing and existing:isType(typeFilter))
		then
			results[id] = existing
		end
	end

	return results
end

function PeripheryNetwork:create(nameOrType, peripherals, options, meta)
	local PeripheralType = self:_resolveNameOrType(nameOrType)
	if not PeripheralType then
		return false, "Invalid virtual peripheral type"
	end

	peripherals = peripherals or {}

	if not self:_isValidConstruction(PeripheralType, peripherals, options) then
		return false, "Invalid construction"
	end

	if not self:_areAllPeripheralsUnclaimed(peripherals) then
		return false, "Some peripherals are claimed"
	end

	local id = self.database:create({
		type = PeripheralType.name,
		peripherals = listUtil.unique(peripherals),
		options = options or {},
		meta = meta or {},
	})

	return id, self:get(id)
end

function PeripheryNetwork:update(id, updateRequest)
	local existing = self.database:get(id)

	if not existing then
		return false, "Not found"
	end

	existing.peripherals = listUtil.unique(updateRequest.peripherals or existing.peripherals)
	existing.options = updateRequest.options or existing.options
	existing.meta = updateRequest.meta or existing.meta

	local PeripheralType = self:_resolveNameOrType(existing.type)
	if not self:_isValidConstruction(PeripheralType, existing.peripherals, existing.options) then
		return false, "Invalid construction"
	end

	local areAllUnclaimed, claimingIds = self:_areAllPeripheralsUnclaimed(existing.peripherals)

	if areAllUnclaimed or (claimingIds and #claimingIds == 1 and claimingIds[1] == id) then
		self.database:update(id, existing)
	else
		return false, "Some peripherals are claimed"
	end


	self.virtualPeripherals[id] = nil
	return self:get(id)
end

function PeripheryNetwork:delete(id)
	self.virtualPeripherals[id] = nil
	self.database:delete(id)
end

function PeripheryNetwork:canAddPeripherals(id, peripherals)
	local existing = self.database:get(id)

	if not existing then
		return false, "Not found"
	end

	local resultingPeripherals = listUtil.combine(existing.peripherals, peripherals)
	local PeripheralType = self:_resolveNameOrType(existing.type)

	if not self:_isValidConstruction(PeripheralType, resultingPeripherals, existing.options) then
		return false, "Invalid construction"
	end

	return true
end

function PeripheryNetwork:addPeripherals(id, peripherals)
	assert(self:canAddPeripherals(id, peripherals))
	local existing = self.database:get(id)
	return self:update(id, {
		peripherals = listUtil.combine(existing.peripherals, peripherals)
	})
end

function PeripheryNetwork:removePeripherals(id, peripherals)
	local existing = self.database:get(id)

	local resultingPeripherals = {}
	local peripheralsToRemove = listUtil.toSet(peripherals)
	for i, existingPeripheral in pairs(existing.peripherals) do
		if not peripheralsToRemove[existingPeripheral] then
			table.insert(resultingPeripherals, existingPeripheral)
		end
	end

	return self:update(id, {
		peripherals = resultingPeripherals
	})
end

function PeripheryNetwork:getAttachedPeripherals(id)
	local existing = self.database:get(id)
	return (existing and existing.peripherals) or {}
end

function PeripheryNetwork:listUnclaimedPeripherals()
	local allPeripherals = peripheral.getNames()
	local claimedPeripherals = listUtil.toSet(self:_getClaimedPeripherals())

	local results = {}
	for i, peripheralName in pairs(allPeripherals) do
		if not claimedPeripherals[peripheralName] then
			table.insert(results, peripheralName)
		end
	end

	return results
end

function PeripheryNetwork:listVirtualPeripheralTypes()
	local results = {}
	for i,v in pairs(self.peripheralTypes) do
		table.insert(results, v)
	end
	return results
end

function PeripheryNetwork:getVirtualPeripheralType(typeName)
	return self.peripheralTypes[typeName]
end

function PeripheryNetwork:_resolveNameOrType(nameOrType)
	if type(nameOrType) == "table" then
		assert(self.peripheralTypes[nameOrType.name] == nameOrType and nameOrType:isType(VirtualPeripheralBase), "virtual peripheral type mismatch")
		return nameOrType
	end

	assert(type(nameOrType) == "string", "invalid nameOrType")
	return self.peripheralTypes[nameOrType]
end

function PeripheryNetwork:_getClaimedPeripherals()
	local results = {}
	for i, record in self.database:enumerateAll() do
		listUtil.insertAll(results, table.unpack(record.peripherals or {}))
	end
	return results
end

function PeripheryNetwork:_arePeripheralsPotentialMatch(PeripheralType, peripherals)
	local validator = PeripheralType.getPeripheralValidator()

	for i, peripheralName in pairs(peripherals) do
		if not matchers.isMatch({peripheral.getType(peripheralName)}, validator) then
			return false, "Invalid peripheral type"
		end
	end

	return true
end

function PeripheryNetwork:_isValidConstruction(PeripheralType, peripherals, options)
	return self:_arePeripheralsPotentialMatch(PeripheralType, peripherals) and PeripheralType.canConstruct(peripherals, options)
end

function PeripheryNetwork:_areAllPeripheralsUnclaimed(peripherals)
	local claimingIdsSet = {}
	for id, record in self.database:enumerateAll() do
		for j, peripheralName in pairs(peripherals) do
			if listUtil.contains(record.peripherals, peripheralName) then
				claimingIdsSet[id] = true
			end
		end
	end

	local claimingIds = tableUtil.keys(claimingIdsSet)
	if #claimingIds > 0 then
		return false, claimingIds
	end

	return true
end

return PeripheryNetwork
