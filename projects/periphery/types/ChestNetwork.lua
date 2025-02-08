local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local matchers = require("periphery.peripheralMatchers")
local nbtUtil = require("util.nbt")

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
		wrappedChests[v] = peripheral.wrap(v)
	end

	self:initProperties({
		chests = wrappedChests,
		limit = limit or -1,
		cachedInventory = nil
	})
end

function ChestNetwork:canAcceptPeripheral(peripheralName)
	return not self.chests[peripheralName] and matchers.isMatch({peripheral.getType(peripheralName)}, self.getPeripheralTypes()) and (self.limit == -1 or #self.chests < self.limit)
end

function ChestNetwork:acceptPeripheral(peripheralName)
	assert(self:canAcceptPeripheral(peripheralName), "cannot accept peripheral")
	self.chests[peripheralName] = peripheral.wrap(peripheralName)
	self.cachedInventory = nil
end

--- A limit of how many chests can be used in the network, defaults to no limit
function ChestNetwork:getChestLimit()
	return self.limit
end

function ChestNetwork:list()
	return self:_scanInventory()
end

function ChestNetwork:_scanInventory()
	if self.cachedInventory ~= nil then
		return self.cachedInventory
	end

	local results = {}
	for chestName, chest in pairs(self.chests) do
		for index, item in pairs(chest.list()) do
			local parsedName = nbtUtil.parseName(item.name)
			results[item.name] = results[item.name] or {
				id = item.name,
				name = parsedName.itemName,
				source = parsedName.source,
				count = 0,
				locations = {}
			}
			results[item.name].count = results[item.name].count + item.count
			table.insert(results[item.name].locations, { chestName = chestName, index = index, count = item.count })
		end
	end

	self.cachedInventory = results
	return results
end

return ChestNetwork
