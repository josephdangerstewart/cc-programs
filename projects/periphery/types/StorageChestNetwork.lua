local ChestNetwork = require("periphery.types.ChestNetwork")

local StorageChestNetwork = ChestNetwork:extend({
	meta = {
		name = "Storage Chest",
		description = "A network of chests that acts as one inventory",
	},
	name = "StorageChestNetwork"
})

return StorageChestNetwork
