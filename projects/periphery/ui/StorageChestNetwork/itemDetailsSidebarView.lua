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
end
