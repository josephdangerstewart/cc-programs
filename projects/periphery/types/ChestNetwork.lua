local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local matchers = require("periphery.peripheralMatchers")
local nbtUtil = require("util.nbt")

local ChestNetwork = VirtualPeripheralBase:extend({
	getPeripheralValidator = function()
		return matchers.requireAny(
			matchers.requireChest("minecraft:chest"),
			matchers.requireChest("create:item_vault")
		)
	end,
	name = "ChestNetwork"
})

function ChestNetwork:init(chests)
	self.super:init({
		name = "Chest Network",
		description = "A wrapper to treat multiple inventories as one (use an derived class for more specialized purposes such as input, output, and storage)",
	})

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
		cachedInventory = nil
	})
end

function ChestNetwork:isItemAllowed(itemName)
	return true
end

function ChestNetwork:refresh()
	self:_clearCache()
end

function ChestNetwork:list()
	return self:_scanInventory()
end

function ChestNetwork:output(itemName, count, destination)
	return self:_transfer(self, self:_getChestNetwork(destination), itemName, count)
end

function ChestNetwork:input(itemName, count, source)
	return self:_transfer(self:_getChestNetwork(source), self, itemName, count)
end

function ChestNetwork:_getChestNetwork(chestOrNetwork)
	if self.chests[chestOrNetwork] then
		return self
	end

	if type(chestOrNetwork) == "string" and matchers.isMatch({peripheral.getType(chestOrNetwork)}, ChestNetwork.getPeripheralValidator()) then
		return ChestNetwork:new(chestOrNetwork)
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

	-- TODO: iterate items out of fromNetwork into toNetwork until count is met or toNetwork is full
	local remaining = count
	local targetLocationIterator = toNetwork:_iterateTargetLocations(item)
	local destinationChest, destinationSlot = targetLocationIterator()

	for sourceChest, sourceSlot in fromNetwork:_iterateSourceLocations(item) do
		if not destinationChest then
			return false, "Destination is full"
		end

		local wrappedDestination = peripheral.wrap(destinationChest)
		print(destinationChest, peripheral.wrap(sourceChest))
		remaining = remaining - wrappedDestination.pullItems(sourceChest, sourceSlot, remaining, destinationSlot)

		fromNetwork:_clearCache()
		toNetwork:_clearCache()
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
	local chestIterator = {pairs(chests)}

	return function()
		for chestName, slot, count in existingSlotIterator do
			local limit = math.min(chests[chestName].getItemLimit(slot), chests[chestName].getItemDetail(slot).maxCount)
			if count < limit then
				return chestName, slot, count
			end
		end

		for chestName in table.unpack(chestIterator) do
			return chestName
		end
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

		return location.chestName, location.index, location.count
	end
end

function ChestNetwork:_clearCache()
	self.cachedInventory = nil
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
