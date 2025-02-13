local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.deviceSettings.deviceSettingsView")

local DeviceSettingsController = ControllerBase:extendWithView(view)

function DeviceSettingsController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController,
	})
end

function DeviceSettingsController:back()
	self.app:changeScreen("devices")
end

return DeviceSettingsController
