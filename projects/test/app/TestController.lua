local Controller = require("mvc.ControllerBase")
local view = require("test.app.testView")

local TestController = Controller:extendWithView(view)

function TestController:init(owningPanel, appController)
	self.super:init(owningPanel)

	self:initProperties({
		appController = appController
	})
end

function TestController:handleClick()
	self.appController:changeScreen("other")
end

return TestController;
