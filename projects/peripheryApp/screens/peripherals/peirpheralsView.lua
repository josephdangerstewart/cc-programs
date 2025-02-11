return function(owningFrame, controller)
	local peripheralsContainer = owningFrame
		:addFlexbox()
		:setBackground(colors.white)
		:setWrap("wrap")
		:setPosition(1, 1)
		:setSize("parent.w", "parent.h - 1")

	owningFrame
		:addButton()
		:setPosition("parent.w - self.w - 1", "parent.h")
		:setSize(7, 1)
		:setText("New +")
		:setForeground(colors.white)
		:onClick(function()
			controller:newPeripheral()
		end)

	return {
		peripheralsContainer = peripheralsContainer
	}
end
