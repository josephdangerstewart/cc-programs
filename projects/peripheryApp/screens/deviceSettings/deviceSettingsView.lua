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

	owningFrame
		:addButton()
		:setText("Delete")
		:setBackground(colors.red)
		:setForeground(colors.white)
		:setPosition("parent.w - self.w + 1", "parent.h")
		:setSize(8, 1)
		:onClick(function()
			controller:delete()
		end)
	
	return {
		titleLabel = titleLabel,
		owningFrame = owningFrame,
	}
end
