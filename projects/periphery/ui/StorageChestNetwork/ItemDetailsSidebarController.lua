local ControllerBase = require("mvc.ControllerBase")
local IOChest = require("periphery.types.IOChest")
local view = require("periphery.ui.StorageChestNetwork.itemDetailsSidebarView")

local ItemDetailsSidebarController = ControllerBase:extendWithView(view)

function ItemDetailsSidebarController:init(owningFrame, parent, item)
	self.super:init(owningFrame)

	self:initProperties({
		parent = parent,
		item = item,
		device = parent.device,
		periphery = parent.periphery,
	})

	self:refresh()
end

function ItemDetailsSidebarController:close()
	self.parent:closeItemSidebar()
end

function ItemDetailsSidebarController:refresh()
	self.view.nameLabel:setText(self.item.name)
	self.view.countLabel:setText("Count: " .. self.item.count)
	self.view.amountInput:setValue("1")

	self.view.outputDropdown:clear()
	local outputOptions = self.periphery:list(IOChest.name)

	for i, outputDevice in pairs(outputOptions) do
		self.view.outputDropdown:addItem(outputDevice.meta.name or "Unamed Device")
	end
end

function ItemDetailsSidebarController:submit()
	self.parent:closeItemSidebar()
end

return ItemDetailsSidebarController
