local RoutedControllerBase = require("mvc.RoutedControllerBase")
local view = require("periphery.ui.StorageChestNetwork.storageChestNetworkView")

local ItemListController = require("periphery.ui.StorageChestNetwork.ItemListController")
local ItemDetailController = require("periphery.ui.StorageChestNetwork.ItemDetailController")

local StorageChestNetworkController = RoutedControllerBase:extendWithView(view)

function StorageChestNetworkController:init(owningFrame, parentController, chestNetwork)
	self.super:init(owningFrame)

	self:initProperties({
		device = chestNetwork,
	})

	self:registerScreen(ItemListController, "itemList")
	self:registerScreen(ItemDetailController, "itemDetail")
end

return StorageChestNetworkController
