local basaltUtil = require("ui.basaltUtil")

return function(owningPanel, controller)
	local rootContentId = "rootContent"

	local rootContent = owningPanel
		:addFrame(rootContentId)
		:setBackground(false)
		:setSize(12, 1)

	local dropdownId = "dropdown"
	local buttonId = "button"

	local dropdown = owningPanel
		:addDropdown(dropdownId)
		:setBackground(colors.gray)
	
	local button = owningPanel
		:addButton(buttonId)
		:setBackground(colors.gray)
		:setText("Go")
		:setSize(2, 1)

	button
		:setPosition(dropdownId .. ".w + 1 + " .. rootContentId .. ".x", rootContentId .. ".y")
		:onClick(function()
			controller:submit()
		end)

	dropdown
		:setSize(rootContentId .. ".w - " .. buttonId .. ".w + 1", 1)
		:setPosition(rootContentId .. ".x", rootContentId .. ".y")

	return {
		rootElement = rootContent,
		button = button,
		dropdown = dropdown,
	}
end
