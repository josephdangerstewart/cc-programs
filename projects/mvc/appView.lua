return function(owningPanel, controller)
	local rootFrame = owningPanel
		:addFrame()
		:setBackground(colors.white)
		:setPosition(1, 2)
		:setSize("parent.w", "parent.h - 1")

	local toolbar = owningPanel
		:addFrame()
		:setPosition(1,1)
		:setSize("parent.w", 1)
		:setBackground(colors.black)

	local navMenu = toolbar
		:addMenubar()
		:setPosition(1,1)
		:setBackground(colors.black)
		:setForeground(colors.lightGray)
		:setSize("parent.w - 1", 1)
		:setSpace(1)
		:setSelectionColor(colors.gray, colors.white)
		:onChange(function()
			controller:navMenuChanged()
		end)
	
	local closeButton = toolbar
		:addButton()
		:setPosition("parent.w", 1)
		:setText("X")
		:setSize(1, 1)
		:setBackground(colors.red)
		:setForeground(colors.white)
		:onClick(function()
			controller:stopApp()
		end)
	
	return {
		rootFrame = rootFrame,
		toolbar = toolbar,
		closeButton = closeButton,
		navMenu = navMenu,
	}
end
