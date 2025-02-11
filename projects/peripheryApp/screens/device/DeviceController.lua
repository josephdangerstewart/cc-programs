local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.device.deviceView")

local DeviceController = ControllerBase:extendWithView(view)

function DeviceController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController,
		id = nil,
	})
end

function DeviceController:onShow(options)
	self.id = options.id
	self.view.label:setText(options.label or ("Device " .. options.id))
end

function DeviceController:back()
	self.app:changeScreen("devices")
end

function DeviceController:settings()
	self:back()
end

return DeviceController
