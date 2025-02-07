local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local matchers = require("periphery.peripheralMatchers")
local listUtil = require("util.list")

local ChestNetwork = VirtualPeripheralBase:extend({
	getPeripheralTypes = function()
		return matchers.requireAny(
			matchers.requireChest("minecraft:chest"),
			matchers.requireChest("create:item_vault")
		)
	end
})

function ChestNetwork:init(chests, limit)
	self.super:init({
		name = "Chest Network",
		description = "A wrapper to treat multiple inventories as one (use an derived class for more specialized purposes such as input, output, and storage)",
	})

	chests = type(chests) == "table" and chests or {chests}

	assert(limit == nil or #chests <= limit, "too many chests")

	local wrappedChests = {}
	for i,v in pairs(chests or {}) do
		if not matchers.isMatch({peripheral.getType(v)}, self.getPeripheralTypes()) then
			error("tried to wrap non-inventory peripheral")
		end
		table.insert(wrappedChests, peripheral.wrap(v))
	end

	self:initProperties({
		chests = wrappedChests,
		chestNames = chests,
		limit = limit or -1
	})
end

function ChestNetwork:canAcceptPeripheral(peripheralName)
	return not listUtil.contains(self.chestNames, peripheralName) and matchers.isMatch({peripheral.getType(peripheralName)}, self.getPeripheralTypes()) and (self.limit == -1 or #self.chests < self.limit)
end

function ChestNetwork:acceptPeripheral(peripheralName)
	assert(self:canAcceptPeripheral(peripheralName), "cannot accept peripheral")
	table.insert(self.chests, peripheral.wrap(peripheralName))
	table.insert(self.chestNames, peripheralName)
end

--- A limit of how many chests can be used in the network, defaults to no limit
function ChestNetwork:getChestLimit()
	return self.limit
end

function ChestNetwork:list()
	local results = {}
	for i, chest in pairs(self.chests) do
		listUtil.insertAll(results, table.unpack(chest.list()))
	end
	return results
end

return ChestNetwork
