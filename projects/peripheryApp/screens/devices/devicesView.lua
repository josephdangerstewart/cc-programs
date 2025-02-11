return function(owningFrame, controller)
	local devicesContainer = owningFrame
		:addScrollableFrame()
		:setBackground(colors.white)
		:setPosition(1, 1)
		:setSize("parent.w", "parent.h - 1")

	owningFrame
		:addButton()
		:setPosition("parent.w - self.w - 1", "parent.h")
		:setSize(7, 1)
		:setText("New +")
		:setBackground(colors.lightGray)
		:onClick(function()
			controller:newDevice()
		end)

	return {
		devicesContainer = devicesContainer
	}
end
