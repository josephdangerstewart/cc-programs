local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemListView")
local basalt = require("lib.basalt")

local ItemListController = ControllerBase:extendWithView(view)

function ItemListController:init(owningFrame, storageController)
	self.super:init(owningFrame)

	self:initProperties({
		storageController = storageController,
	})
end

function ItemListController:onSelect(item)
	self:openItemSidebar()
end

function ItemListController:onShow()
	self:refresh()
end

function ItemListController:closeItemSidebar()
	self.view.itemDetailSidebar:hide()
	self.view.mainContentFrame:setSize("parent.w", "parent.h")
end

function ItemListController:openItemSidebar()
	self.view.itemDetailSidebar:show()
	local sidebarWidth = self.view.itemDetailSidebar:getSize()
	self.view.mainContentFrame:setSize("parent.w - " .. sidebarWidth, "parent.h")
end

function ItemListController:refresh(force)
	local items = self.storageController.device:list(force)

	local results = {}
	for i,item in pairs(items) do
		results[i] = {
			text = item.name,
			subText = "x" .. item.count
		}
	end

	self.view.itemList:setItems(results)
end

return ItemListController
