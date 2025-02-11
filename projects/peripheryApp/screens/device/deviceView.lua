return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("<")
		:setSize(1, 1)
		:setPosition(1, 1)
		:setBackground(colors.white)
		:setForeground(colors.black)
		:onClick(function()
			controller:back()
		end)

	owningFrame
		:addLabel()
		:setText("Device")
		:setPosition(3, 1)

	owningFrame
		:addButton()
		:setText("Settings")
		:setSize(10, 1)
		:setPosition("parent.w - self.w + 1", 1)
		:setBackground(colors.gray)
		:setForeground(colors.white)
		:onClick(function()
			controller:settings()
		end)

	local content = owningFrame
		:addFrame()
		:setSize("parent.w", "parent.h - 1")
		:setPosition(1, 2)
		:setBackground(colors.white)

	return {
		content = content
	}
end
