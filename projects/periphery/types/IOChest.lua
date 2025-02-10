local ChestNetwork = require("ChestNetwork")
local matchers = require("periphery.peripheralMatchers")

local IOChest = ChestNetwork:extend({
	getPeripheralValidator = function()
		return matchers.requireAny(
			matchers.requireChest("minecraft:chest"),
			matchers.requireChest("create:item_vault")
		)
	end,
	canConstruct = function(peripherals)
		peripherals = peripherals or {}
		return #peripherals <= 1
	end,
	meta = {
		name = "IO Chest",
		description = "A single chest for inputting and outputting items",
	},
	name = "IOChest"
})

function IOChest:intake(destination)
	self:refresh()
	for itemName, item in ipairs(self:list()) do
		self:output(itemName, item.count, destination)
	end
end

return IOChest
