local ColumnList = require("ui.ColumnList")
local basalt = require("lib.basalt")

return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setBackground(colors.blue)
		:setForeground(colors.white)
		:setText("Intake")
		:setSize(8, 1)
		:setPosition(1, 1)
		:onClick(function()
			controller:intake()
		end)

	owningFrame
		:addButton()
		:setText("Refresh")
		:setPosition(10, 1)
		:setSize(7, 1)
		:setBackground(colors.white)
		:setForeground(colors.blue)
		:onClick(function ()
			controller:refresh(true)
		end)

	local clearButton

	local searchInput = owningFrame
		:addInput()
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setDefaultText("Search", colors.gray, colors.lightGray)
		:setPosition(19, 1)
		:setSize(20, 1)
		:onChange(function(_, _, value)
			if value == "" then
				clearButton:setForeground(colors.gray)
			else
				clearButton:setForeground(colors.black)
			end
			controller:onSearch(value)
		end)

	clearButton = owningFrame
		:addButton()
		:setPosition(39, 1)
		:setSize(1, 1)
		:setText("X")
		:setBackground(colors.lightGray)
		:setForeground(colors.gray)
		:onClick(function()
			searchInput:setValue("")
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

	return {
		itemList = itemList,
		mainContentFrame = mainContentFrame,
		itemDetailSidebar = itemDetailSidebar,
	}
end
