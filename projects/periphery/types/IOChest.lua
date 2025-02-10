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
	for itemName, item in pairs(self:list()) do
		local success, error = self:giveItem(itemName, item.count, destination)

		if not success then
			return false, error
		end
	end

	return true
end

function IOChest:list()
	self:refresh()
	return self.super:list()
end

return IOChest
