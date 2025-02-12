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
	self.view.countLabel:setText("Count: " .. self.item.count)
end

function ItemDetailsSidebarController:submit()
	self.parent:closeItemSidebar()
end

return ItemDetailsSidebarController
