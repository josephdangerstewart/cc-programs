local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.storageChestNetworkView")
local ItemDetailsSidebar = require("periphery.ui.StorageChestNetwork.ItemDetailsSidebarController")

local StorageChestNetworkController = ControllerBase:extendWithView(view)

function StorageChestNetworkController:init(owningFrame, parent)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
		device = parent.device,
		periphery = parent.app.periphery,
	})
end

function StorageChestNetworkController:onSelect(item)
	self:openItemSidebar(item)
end

function StorageChestNetworkController:onShow()
	self:refresh()
end

function StorageChestNetworkController:closeItemSidebar()
	self.view.itemDetailSidebar:hide()
	self.view.mainContentFrame:setSize("parent.w", "parent.h")
end

function StorageChestNetworkController:openItemSidebar(item)
	self.view.itemDetailSidebar:removeChildren()
	ItemDetailsSidebar:new(self.view.itemDetailSidebar, self, self.device:list()[item])

	self.view.itemDetailSidebar:show()
	local sidebarWidth = self.view.itemDetailSidebar:getSize()
	self.view.mainContentFrame:setSize("parent.w - " .. sidebarWidth, "parent.h")
end

function StorageChestNetworkController:refresh(force)
	local items = self.device:list(force)

	local results = {}
	for i,item in pairs(items) do
		results[i] = {
			text = item.name,
			subText = "x" .. item.count,
			item = item,
		}
	end

	self.view.itemList:setItems(results)
end

return StorageChestNetworkController
