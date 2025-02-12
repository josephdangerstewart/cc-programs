local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemDetailsSidebarView")

local ItemDetailsSidebarController = ControllerBase:extendWithView(view)

function ItemDetailsSidebarController:init(owningFrame, parent, item)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
		item = item
	})

	self.view.label:setText(item.name)
end

function ItemDetailsSidebarController:close()
	self.parent:closeItemSidebar()
end

return ItemDetailsSidebarController
