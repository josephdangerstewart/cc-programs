local ChestNetwork = require("periphery.types.ChestNetwork")

local IOChest = ChestNetwork:extend({
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
