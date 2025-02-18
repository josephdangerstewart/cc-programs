local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local matchers = require("periphery.peripheralMatchers")
local nbtUtil = require("util.nbt")
local tableUtil = require("util.table")

local ChestNetwork = VirtualPeripheralBase:extend({
	getPeripheralValidator = function()
		return matchers.requireAny(
			matchers.requireChest("minecraft:chest"),
			matchers.requireChest("create:item_vault")
		)
	end,
	meta = {
		name = "Chest Network",
		description = "A wrapper to treat multiple inventories as one (use an derived class for more specialized purposes such as input, output, and storage)",
	},
	name = "ChestNetwork"
})

function ChestNetwork:init(chests, options, peripheryNetwork)
	self.super:init()

	chests = type(chests) == "table" and chests or {chests}

	local wrappedChests = {}
	for i,v in pairs(chests or {}) do
		if not matchers.isMatch({peripheral.getType(v)}, self.getPeripheralValidator()) then
			error("tried to wrap non-inventory peripheral")
		end
		wrappedChests[v] = peripheral.wrap(v)
	end

	self:initProperties({
		chests = wrappedChests,
		cachedInventory = nil,
		peripheryNetwork = peripheryNetwork,
	})
end

function ChestNetwork:isItemAllowed(itemName)
	return true
end

function ChestNetwork:refresh()
	self:_clearCache()
end

function ChestNetwork:list(force)
	return self:_scanInventory(force)
end

function ChestNetwork:giveItem(itemName, count, destination)
	return self:_transfer(self, self:_getChestNetwork(destination), itemName, count)
end

function ChestNetwork:takeItem(itemName, count, source)
	return self:_transfer(self:_getChestNetwork(source), self, itemName, count)
end

function ChestNetwork:_getChestNetwork(chestOrNetwork)
	if type(chestOrNetwork) == "string" then
		if self.chests[chestOrNetwork] then
			return self
		end

		local vPeripheral = self.peripheryNetwork:get(chestOrNetwork)
		if vPeripheral and vPeripheral:isType(ChestNetwork) then
			return vPeripheral
		end

		if matchers.isMatch({peripheral.getType(chestOrNetwork)}, ChestNetwork.getPeripheralValidator()) then
			return ChestNetwork:new(chestOrNetwork)
		end
	end

	if type(chestOrNetwork) == "table" and chestOrNetwork:isType(ChestNetwork) then
		return chestOrNetwork
	end

	return nil
end

function ChestNetwork:_transfer(
	fromNetwork,
	toNetwork,
	item,
	count
)
	fromNetwork:assertIsType(ChestNetwork)
	toNetwork:assertIsType(ChestNetwork)

	if count < 0 then
		return false, "count is less than 0"
	end

	if count == 0 then
		return true
	end

	if not toNetwork:isItemAllowed(item) then
		return false, "item not allowed in target network"
	end

	local sourceInventory = fromNetwork:list()

	if not sourceInventory[item] or sourceInventory[item].count < count then
		return false, "source inventory does not have item in requested quantity"
	end

	local destinationIterator = toNetwork:_iterateTargetLocations(item)
	local sourceIterator = fromNetwork:_iterateSourceLocations(item)

	local destinationChest, destinationSlot = destinationIterator()
	local sourceChest, sourceSlot, sourceCount = sourceIterator()
	local remaining = count

	while destinationChest and sourceChest and remaining > 0 do
		print("s", sourceChest, sourceSlot)
		local wrappedDestination = peripheral.wrap(destinationChest)
		local pulled = wrappedDestination.pullItems(sourceChest, sourceSlot, remaining, destinationSlot)

		if pulled > 0 then
			remaining = remaining - pulled
			sourceCount = sourceCount - pulled

			fromNetwork:refresh()
			toNetwork:refresh()

			if sourceCount <= 0 then
				sourceChest, sourceSlot, sourceCount = sourceIterator()
			end
		else
			destinationChest, destinationSlot = destinationIterator()
		end
	end

	if remaining > 0 then
		return false, "Could not transfer all items"
	end

	return true
end

--- Iterate locations to take itemName from
function ChestNetwork:_iterateSourceLocations(itemName)
	return self:_iterateItemLocations(itemName)
end

function ChestNetwork:_iterateTargetLocations(itemName)
	local existingSlotIterator = self:_iterateItemLocations(itemName)
	local chests = self.chests
	local chestNames = tableUtil.keys(self.chests)
	local chestNameIndex = 0

	return function()
		for chestName, slot, count in existingSlotIterator do
			local limit = math.min(chests[chestName].getItemLimit(slot), chests[chestName].getItemDetail(slot).maxCount)
			if count < limit then
				return chestName, slot, count
			end
		end

		chestNameIndex = chestNameIndex + 1
		return chestNames[chestNameIndex]
	end
end

function ChestNetwork:_iterateItemLocations(itemName)
	local inventory = self:_scanInventory()
	local item = inventory[itemName]
	local locations = (item and item.locations) or {}
	local locationIndex = 0
	local perSlotLimit = -1
	local _self = self

	return function()
		locationIndex = locationIndex + 1
		local location = locations[locationIndex]

		if not location then
			return
		end

		if perSlotLimit == -1 then
			local detail = _self.chests[location.chestName].getItemDetail(location.index)
			perSlotLimit = detail.maxCount
		end

		print("si", location.chestName, location.index)
		return location.chestName, location.index, location.count
	end
end

function ChestNetwork:_clearCache()
	self.cachedInventory = nil
end

function ChestNetwork:_scanInventory(force)
	if self.cachedInventory ~= nil and not force then
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
