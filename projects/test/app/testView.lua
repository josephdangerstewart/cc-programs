local basalt = require("lib.basalt")

return function (owningFrame, controller)
	local container = owningFrame:addFrame():setBackground(colors.white);

	container
		:addButton()
		:setText("Click me")
		:setForeground(colors.white)
		:setPosition(2, 2)
		:setHorizontalAlign("center")
		:onClick(function()
			controller:handleClick()
		end)
end
