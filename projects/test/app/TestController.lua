local Controller = require("mvc.ControllerBase")
local view = require("test.app.testView")

local TestController = Controller:extendWithView(view)

function TestController:init(owningPanel)
	self.super:init(owningPanel)
end

return TestController;
