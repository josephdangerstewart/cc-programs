local UIElementControllerBase = require("mvc.UIElementControllerBase")
local initView = require("ui.ColumnList.columnListView")
local basalt = require("lib.basalt")

local ColumnListController = UIElementControllerBase:extendWithView(initView)

function ColumnListController:init(owningFrame)
	self.super:init(owningFrame)

	self:initProperties({
		labels = {},
		onSelectHandlers = {},
	})
end

function ColumnListController:onSelect(handler)
	table.insert(self.onSelectHandlers, handler)
	return self
end

function ColumnListController:clear()
	self:setItems({})
end

function ColumnListController:setItems(items)
	for i,label in ipairs(self.labels) do
		label:remove()
	end
	self.labels = {}

	local height = self.view.scrollingFrame:getHeight()

	local column = 1
	local row = 1
	local maxWidth = 0

	for key, item in pairs(items) do
		local text = item.text
		local subText = item.subText and " " .. item.subText

		local function handleTextClick()
			for i,handler in ipairs(self.onSelectHandlers) do
				handler(key, item)
			end
		end

		local countLabel
		if subText then
			countLabel = self.view.scrollingFrame
				:addLabel()
				:setSize(#subText, 1)
				:setPosition(column + #text, row)
				:setForeground(colors.lightGray)
				:setText(subText)
				:onClick(handleTextClick)
		end

		local nameLabel = self.view.scrollingFrame
			:addLabel()
			:setSize(#text, 1)
			:setPosition(column, row)
			:setText(text)
			:onClick(handleTextClick)
		
		table.insert(self.labels, nameLabel)
		table.insert(self.labels, countLabel)

		maxWidth = math.max(#text + #subText + 1, maxWidth)
		row = row + 1

		if row > height then
			row = 1
			column = column + maxWidth
			maxWidth = 0
		end
	end

	self:_measureChildren()
	return self
end

function ColumnListController:getScrollAmount()
	return self.scrollAmount or 0
end

function ColumnListController:_measureChildren()
	local maxX = 0
	local containerWidth = self.view.scrollingFrame:getWidth()

	for i,child in pairs(self.view.scrollingFrame:getChildren()) do
		local x = child.element:getX()
		local width = child.element:getWidth()
		maxX = math.max(maxX, x + width)
	end

	self.scrollAmount = maxX - containerWidth
	self.view.scrollBar:setScrollAmount(self.scrollAmount)
end

return ColumnListController
