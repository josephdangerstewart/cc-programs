local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemDetailsSidebarView")

local ItemDetailsSidebarController = ControllerBase:extendWithView(view)

function ItemDetailsSidebarController:init(owningFrame, parent)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
	})
end

function ItemDetailsSidebarController:close()
	self.parent:closeItemSidebar()
end

return ItemDetailsSidebarController
