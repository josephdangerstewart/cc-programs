local UIElementControllerBase = require("mvc.UIElementControllerBase")
local view = require("ui.ComboBox.comboBoxView")

local ComboBoxController = UIElementControllerBase:extendWithView(view)

function ComboBoxController:init(owningFrame)
	self.super:init(owningFrame)

	self:initProperties({
		onSubmitHooks = {}
	})
end

function ComboBoxController:setItems(itemsOrFunc)
	if type(itemsOrFunc) == "function" then
		self.itemSource = itemsOrFunc
	else
		self.itemSource = function()
			return itemsOrFunc
		end
	end

	self:refreshItems()
	return self
end

function ComboBoxController:setButtonText(text)
	self.view.button:setText(text)
	self.view.button:setSize(#text, 1)
	return self
end

function ComboBoxController:refreshItems()
	self.view.dropdown:clear()

	if not self.itemSource then
		return self
	end

	self.items = self.itemSource()

	for i, item in pairs(self.items) do
		self.view.dropdown:addItem(item.text)
	end

	return self
end

function ComboBoxController:setBackground(color)
	self.view.dropdown:setBackground(color)
	self.view.button:setBackground(color)
	return self
end

function ComboBoxController:submit()
	if not self:_isValid() then
		return
	end

	self:_runOnChangeHooks()
end

function ComboBoxController:onSubmit(func)
	table.insert(self.onSubmitHooks, func)
	return self
end

function ComboBoxController:getValue()
	if not self.items then
		return
	end

	local selectedItem = self.view.dropdown:getItemIndex()
	return self.items[selectedItem]
end

function ComboBoxController:_runOnChangeHooks()
	local value = self:getValue()

	if not value then
		return
	end

	for i,hook in pairs(self.onSubmitHooks) do
		hook(value)
	end
end


function ComboBoxController:_isValid()
	return self.items and #self.items > 0
end

return ComboBoxController
