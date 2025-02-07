local ControllerBase = require("mvc.ControllerBase")
local otherView = require("test.app.otherScreenView")

local OtherScreenController = ControllerBase:extendWithView(otherView)

function OtherScreenController:init(owningFrame)
	self.super:init(owningFrame)
end

return OtherScreenController
