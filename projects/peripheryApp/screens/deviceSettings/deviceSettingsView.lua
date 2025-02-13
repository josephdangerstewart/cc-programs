local CheckboxList = require("ui.CheckboxList")

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

	owningFrame
		:addLabel()
		:setText("Attached Peripherals")
		:setPosition(2, 3)

	local attachedPeripheralsList = CheckboxList
		:new(owningFrame)
		:setPosition(2, 4)
		:setSize(20, 8)

	owningFrame
		:addButton()
		:setText("Remove Peripherals")
		:setSize(20, 1)
		:setBackground(colors.blue)
		:setForeground(colors.white)
		:setPosition(2, 13)
		:onClick(function()
			controller:removePeripherals()
		end)

	owningFrame
		:addLabel()
		:setText("Unclaimed Peripherals")
		:setPosition(24, 3)

	local unclaimedPeripheralsList = CheckboxList
		:new(owningFrame)
		:setPosition(24, 4)
		:setSize(20, 8)

	owningFrame
		:addButton()
		:setText("Add Peripherals")
		:setSize(17, 1)
		:setBackground(colors.blue)
		:setForeground(colors.white)
		:setPosition(25, 13)
		:onClick(function()
			controller:addPeripherals()
		end)
	
	return {
		titleLabel = titleLabel,
		owningFrame = owningFrame,
		attachedPeripheralsList = attachedPeripheralsList,
		unclaimedPeripheralsList = unclaimedPeripheralsList,
	}
end
