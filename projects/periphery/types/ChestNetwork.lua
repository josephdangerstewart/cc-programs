local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local matchers = require("periphery.peripheralMatchers")

local ChestNetwork = VirtualPeripheralBase:extend({
	getPeripheralTypes = function()
		return matchers.requireAny(
			matchers.requireChest("minecraft:chest"),
			matchers.requireChest("create:item_vault")
		)
	end
})

function ChestNetwork:init(chests)
	self.super:init({
		name = "Chest Network",
		description = "A wrapper to treat multiple inventories as one (use an derived class for more specialized purposes such as input, output, and storage)",
	})

	self:initProperties({
		chests = chests or {}
	})
end

--- A limit of how many chests can be used in the network, defaults to no limit
function ChestNetwork:getChestLimit()
	return -1
end

return ChestNetwork
