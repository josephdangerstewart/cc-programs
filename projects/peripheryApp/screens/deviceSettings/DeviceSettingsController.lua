local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.deviceSettings.deviceSettingsView")

local DeviceSettingsController = ControllerBase:extendWithView(view)

function DeviceSettingsController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController,
	})
end

function DeviceSettingsController:onShow(options)
	self.device = options.device

	local meta = self.app.periphery:getDeviceMeta(self.device:getId())
	self.view.titleLabel:setText(meta and meta.name or "Device Settings")
end

function DeviceSettingsController:back()
	self.app:changeScreen("device", { id = self.device:getId() })
end

function DeviceSettingsController:delete()
	self.app.periphery:delete(self.device:getId())
	self.app:changeScreen("devices")
end

return DeviceSettingsController
