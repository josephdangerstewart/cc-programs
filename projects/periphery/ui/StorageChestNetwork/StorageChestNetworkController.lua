local ControllerBase = require("mvc.ControllerBase")
local IOChest = require("periphery.types.IOChest")
local view = require("periphery.ui.StorageChestNetwork.storageChestNetworkView")
local basalt = require("lib.basalt")
local ItemDetailsSidebar = require("periphery.ui.StorageChestNetwork.ItemDetailsSidebarController")

local StorageChestNetworkController = ControllerBase:extendWithView(view)

function StorageChestNetworkController:init(owningFrame, parent)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
		device = parent.device,
		periphery = parent.app.periphery,
		sortProperty = "name",
		search = ""
	})
end

function StorageChestNetworkController:onSelect(itemIndex)
	self:openItemSidebar(self.sortedItems[itemIndex])
end

function StorageChestNetworkController:onShow()
	self:refresh()
end

function StorageChestNetworkController:closeItemSidebar()
	self.view.itemDetailSidebar:hide()
	self.view.mainContentFrame:setSize("parent.w", "parent.h - 1")
end

function StorageChestNetworkController:openItemSidebar(item)
	self.view.itemDetailSidebar:removeChildren()
	self.itemDetailsSidebarController = ItemDetailsSidebar:new(self.view.itemDetailSidebar, self, item)

	self.view.itemDetailSidebar:show()
	local sidebarWidth = self.view.itemDetailSidebar:getSize()
	self.view.mainContentFrame:setSize("parent.w - " .. sidebarWidth, "parent.h - 1")
end

function StorageChestNetworkController:intake()
	local ioChests = self.periphery:list(IOChest.name)

	for i, chest in pairs(ioChests) do
		chest.virtualPeripheral:intake(self.device)
	end

	self:refresh()
	if self.itemDetailsSidebarController then
		self.itemDetailsSidebarController:refresh()
	end
end

function StorageChestNetworkController:refresh(force)
	local items = self.device:list(force)

	local sortedItems = {}
	for i,item in pairs(items) do
		if self.search == "" or string.find(item.name, self.search) then
			table.insert(sortedItems, item)
		end
	end

	local sortBy = self.sortProperty
	table.sort(sortedItems, function (a, b)
		return a[sortBy] < b[sortBy]
	end)

	self.sortedItems = sortedItems
	local results = {}
	for i,item in pairs(sortedItems) do
		table.insert(results, {
			text = item.name,
			subText = "x" .. item.count,
			item = item,
		})
	end

	self.view.itemList:setItems(results)
end

function StorageChestNetworkController:onSearch(value)
	self.search = value
	self:refresh()
end

return StorageChestNetworkController
