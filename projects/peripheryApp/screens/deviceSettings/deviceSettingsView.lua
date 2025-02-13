return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("<")
		:setPosition(1, 1)
		:setSize(1, 1)
		:setBackground(colors.white)
		:setForeground(colors.black)
		:onClick(function()
			controller:back()
		end)

	local titleLabel = owningFrame
		:addLabel()
		:setText("Device Settings")
		:setPosition(3, 1)
	
	return {
		titleLabel = titleLabel,
	}
end
