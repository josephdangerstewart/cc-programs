local UIElementControllerBase = require("mvc.UIElementControllerBase")
local view = require("ui.CheckboxList.checkboxListView")

local CheckboxListController = UIElementControllerBase:extendWithView(view)

function CheckboxListController:init(owningFrame)
	self.super:init(owningFrame)

	self:initProperties({
		children = {},
		onChangeHooks = {},
		checkboxes = {}
	})
end

function CheckboxListController:addItem(item)
	table.insert(self.children, item)
	local _self = self

	local container = self.rootElement
		:addFrame()
		:setPosition(1, #self.children)
		:setSize("parent.w", 1)
		:setBackground(item.bgCol or item.background or colors.gray)
		:setForeground(item.fgCol or item.foreground or colors.black)

	local checkbox = container
		:addCheckbox()
		:setPosition(1, 1)
		:onChange(function()
			_self:_runOnChange()
		end)

	table.insert(self.checkboxes, checkbox)

	container
		:addLabel()
		:setText(item.text)
		:setPosition(2, 1)
		:onClick(function()
			checkbox:setValue(not checkbox:getValue())
		end)

	return self
end

function CheckboxListController:onChange(func)
	table.insert(self.onChangeHooks, func)
	return self
end

function CheckboxListController:clear()
	self.children = {}
	self.checkboxes = {}
	self.rootElement:removeChildren()
	return self
end

function CheckboxListController:getValue()
	local results = {}

	for index, checkbox in pairs(self.checkboxes) do
		if checkbox:getValue() then
			table.insert(results, self.children[index])
		end
	end

	return results
end

function CheckboxListController:_runOnChange()
	local results = self:getValue()

	for i,hook in pairs(self.onChangeHooks) do
		hook(self, results)
	end
end

return CheckboxListController
