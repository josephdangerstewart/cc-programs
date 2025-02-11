local RoutedControllerBase = require("mvc.RoutedControllerBase")
local view = require("periphery.ui.StorageChestNetwork.storageChestNetworkView")

local StorageChestNetworkController = RoutedControllerBase:extendWithView(view)

function StorageChestNetworkController:init(owningFrame, deviceController, chestNetwork)
	self.super:init(owningFrame)
end

return StorageChestNetworkController
