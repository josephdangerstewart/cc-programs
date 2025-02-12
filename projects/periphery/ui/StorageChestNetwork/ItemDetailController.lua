local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemDetailView")

local ItemDetailController = ControllerBase:extendWithView(view)

function ItemDetailController:init(owningPanel, parent)
	self.super:init(owningPanel)

	self:initProperties({
		parent = parent,
	})
end

function ItemDetailController:back()
	self.parent:changeScreen("itemList")
end

return ItemDetailController
