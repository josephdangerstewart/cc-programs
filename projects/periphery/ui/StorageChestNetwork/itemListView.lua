local ColumnList = require("ui.ColumnList")

return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("Refresh")
		:setPosition("parent.w - self.w + 1", 1)
		:setSize(9, 1)
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:onClick(function ()
			controller:refresh(true)
		end)

	local itemList = ColumnList
		:new(owningFrame)
		:setSize("parent.w", "parent.h - 1")
		:setPosition(1, 2)
		:onSelect(function(key)
			controller:onSelect(key)
		end)

	return {
		itemList = itemList
	}
end
