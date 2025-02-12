return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("< All Items")
		:setPosition(1, 1)
		:setBackground(colors.white)
		:setForeground(colors.black)
		:setSize(13, 1)
		:onClick(function()
			controller:back()
		end)
end
