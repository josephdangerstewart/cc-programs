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
		outputs = {}
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
	local options = self.periphery:list(IOChest.name)
	self.outputs = {}

	for i, outputDevice in pairs(options) do
		table.insert(self.outputs, outputDevice.virtualPeripheral)
		self.view.outputDropdown:addItem(outputDevice.meta.name or "Unamed Device")
	end

	self:_validateButton()
end

function ItemDetailsSidebarController:handleFormChange()
	self:_validateButton()
end

function ItemDetailsSidebarController:submit()
	if not self:_isValid() then
		return
	end

	local amount = self:_getAmount()
	local output = self:_getOutput()

	self.device:giveItem(self.item.id, amount, output)
	self.parent:closeItemSidebar()
end

function ItemDetailsSidebarController:_validateButton()
	if self:_isValid() then
		self.view.submitButton:setBackground(colors.green)
	else
		self.view.submitButton:setBackground(colors.gray)
	end
end

function ItemDetailsSidebarController:_isValid()
	local amount = self:_getAmount()
	local output = self:_getOutput()

	return amount > 0 and amount <= self.item.count and output
end

function ItemDetailsSidebarController:_getAmount()
	local rawValue = self.view.amountInput:getValue()
	local value = tonumber(rawValue)
	return value or 0
end

function ItemDetailsSidebarController:_getOutput()
	local selectedOutputIndex = self.view.outputDropdown:getItemIndex()
	return self.outputs and self.outputs[selectedOutputIndex]
end

return ItemDetailsSidebarController
