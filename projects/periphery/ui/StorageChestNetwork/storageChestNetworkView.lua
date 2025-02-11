return function(owningFrame, controller)
	return {
		rootFrame = owningFrame
			:addFrame()
			:setPosition(1, 1)
			:setSize("parent.w", "parent.h")
			:setBackground(colors.red),
	}
end
