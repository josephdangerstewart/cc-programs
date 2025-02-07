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
	self:initProperties({
		chests = chests or {}
	})
end

return ChestNetwork
