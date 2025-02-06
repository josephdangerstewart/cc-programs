local basalt = require("lib.basalt")

return function (owningFrame, controller)
	local container = owningFrame:addFrame();

	container:addButton()
		:setText("Click me")
		:setPosition(1, 1)
		:onClick(function()
			basalt.debug("clicked")
		end)
end
