local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemDetailView")

local ItemDetailController = ControllerBase:extendWithView(view)

return ItemDetailController
