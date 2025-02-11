local CheckboxList = require("ui.CheckboxList")

local centerX = "parent.w / 2 - self.w / 2"
local formLeft = 8
local formWidth = "parent.w - 16"

return function(owningFrame, controller)
	owningFrame
		:addButton()
		:setText("<")
		:setBackground(colors.white)
		:setSize(1, 1)
		:setPosition(1, 1)
		:onClick(function ()
			controller:back()
		end)

	owningFrame
		:addLabel()
		:setText("Add Device")
		:setPosition(centerX, 1)

	owningFrame
		:addLabel()
		:setText("Kind")
		:setPosition(formLeft, 3)

	local kindDropdown = owningFrame
		:addDropdown()
		:setPosition(formLeft, 4)
		:setBackground(colors.lightGray)
		:setSize(formWidth, 1)
		:onChange(function()
			controller:handleKindChange()
		end)

	owningFrame
		:addLabel()
		:setText("Peirpherals")
		:setPosition(formLeft, 6)

	local peripheralsList = CheckboxList
		:new(owningFrame)
		:setPosition(formLeft, 7)
		:setBackground(colors.lightGray)
		:setSize(formWidth, 5)
		:onChange(function()
			controller:handleFormChange()
		end)

	owningFrame
		:addLabel()
		:setText("Name")
		:setPosition(formLeft, 13)

	local nameInput = owningFrame
		:addInput()
		:setBackground(colors.lightGray)
		:setForeground(colors.black)
		:setPosition(formLeft, 14)
		:setDefaultText("", colors.black, colors.lightGray)
		:setSize(formWidth, 1)
		:onChange(function()
			controller:handleFormChange()
		end)

	local submitButton = owningFrame
		:addButton()
		:setText("Create")
		:setPosition(centerX, 16)
		:setSize(8, 1)
		:setBackground(colors.green)
		:setForeground(colors.white)
		:onClick(function()
			controller:handleSubmit()
		end)

	return {
		kindDropdown = kindDropdown,
		peripheralsList = peripheralsList,
		nameInput = nameInput,
		submitButton = submitButton,
	}
end
