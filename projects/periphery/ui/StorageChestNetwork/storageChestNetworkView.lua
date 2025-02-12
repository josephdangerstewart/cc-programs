local ColumnList = require("ui.ColumnList")

return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("Refresh")
		:setPosition(1, 1)
		:setSize(7, 1)
		:setBackground(colors.white)
		:setForeground(colors.blue)
		:onClick(function ()
			controller:refresh(true)
		end)

	local mainContentFrame = owningFrame
		:addFrame()
		:setBackground(colors.white)
		:setSize("parent.w", "parent.h - 1")
		:setPosition(1, 2)

	local itemList = ColumnList
		:new(mainContentFrame)
		:setSize("parent.w", "parent.h")
		:setPosition(1, 1)
		:onSelect(function(key)
			controller:onSelect(key)
		end)

	local itemDetailSidebar = owningFrame
		:addFrame()
		:setBackground(colors.lightGray)
		:setSize("parent.w / 3", "parent.h")
		:setPosition("parent.w - self.w + 1", 1)
		:hide()

	itemDetailSidebar
		:addButton()
		:setText("X")
		:setSize(1, 1)
		:setPosition(1, 1)
		:setBackground(colors.lightGray)
		:setForeground(colors.gray)
		:onClick(function()
			controller:closeItemSidebar()
		end)

	return {
		itemList = itemList,
		mainContentFrame = mainContentFrame,
		itemDetailSidebar = itemDetailSidebar,
	}
end
