return function(owningFrame, controller)
	local toolbar = owningFrame
		:addFrame()
		:setSize("parent.w", 1)
		:setPosition(1, 1)
		:setBackground(colors.gray)

	toolbar
		:addButton()
		:setText("<")
		:setSize(1, 1)
		:setPosition(1, 1)
		:setBackground(colors.gray)
		:setForeground(colors.lightGray)
		:onClick(function()
			controller:back()
		end)

	local label = toolbar
		:addLabel()
		:setText("Device")
		:setForeground(colors.lightGray)
		:setPosition(3, 1)

	toolbar
		:addButton()
		:setText("Settings")
		:setSize(10, 1)
		:setPosition("parent.w - self.w + 1", 1)
		:setBackground(colors.gray)
		:setForeground(colors.lightGray)
		:onClick(function()
			controller:settings()
		end)

	local content = owningFrame
		:addFrame()
		:setSize("parent.w", "parent.h - 1")
		:setPosition(1, 2)
		:setBackground(colors.white)

	return {
		content = content,
		label = label
	}
end
