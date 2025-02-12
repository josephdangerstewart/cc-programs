return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("X")
		:setSize(1, 1)
		:setPosition(1, 1)
		:setBackground(colors.lightGray)
		:setForeground(colors.gray)
		:onClick(function()
			controller:close()
		end)

	local nameLabel = owningFrame
		:addLabel()
		:setText("Item Name")
		:setPosition(3, 1)

	return {
		nameLabel = nameLabel,
	}
end
