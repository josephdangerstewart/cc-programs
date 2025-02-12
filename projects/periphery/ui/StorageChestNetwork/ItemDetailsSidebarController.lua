local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemDetailsSidebarView")

local ItemDetailsSidebarController = ControllerBase:extendWithView(view)

function ItemDetailsSidebarController:init(owningFrame, parent, item)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
		item = item
	})

	self:refresh()
end

function ItemDetailsSidebarController:close()
	self.parent:closeItemSidebar()
end

function ItemDetailsSidebarController:refresh()
	self.view.nameLabel:setText(self.item.name)
end

return ItemDetailsSidebarController
