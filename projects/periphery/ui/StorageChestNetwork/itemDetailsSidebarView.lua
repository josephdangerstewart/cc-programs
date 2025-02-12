return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("X")
		:setSize(1, 1)
		:setPosition(1, 1)
		:setBackground(colors.lightGray)
		:setForeground(colors.gray)
		:onClick(function()
			controller:close()
		end)

	local nameLabel = owningFrame
		:addLabel()
		:setText("Item Name")
		:setPosition(3, 1)

	local countLabel = owningFrame
		:addLabel()
		:setText("Count: 0")
		:setPosition(1, 3)

	owningFrame
		:addLabel()
		:setText("Take:")
		:setPosition(1, 5)

	local amountInput = owningFrame
		:addInput()
		:setSize("parent.w - 2", 1)
		:setPosition(2, 6)
		:setDefaultText("1", colors.white, colors.gray)
		:setBackground(colors.gray)
		:setForeground(colors.white)
		:setInputType("number")
		:onChange(function()
			controller:handleFormChange()
		end)

	owningFrame
		:addLabel()
		:setText("Output:")
		:setPosition(1, 8)

	local outputDropdown = owningFrame
		:addDropdown()
		:setSize("parent.w - 2", 1)
		:setForeground(colors.white)
		:setPosition(2, 9)
		:onChange(function()
			controller:handleFormChange()
		end)

	local submitButton = owningFrame
		:addButton()
		:setText("Take")
		:setBackground(colors.gray)
		:setForeground(colors.white)
		:setSize("parent.w - 2", 1)
		:setPosition(2, "parent.h - 1")
		:onClick(function ()
			controller:submit()
		end)

	return {
		nameLabel = nameLabel,
		countLabel = countLabel,
		amountInput = amountInput,
		outputDropdown = outputDropdown,
		submitButton = submitButton,
	}
end
