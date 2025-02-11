local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.device.deviceView")
local peripheryUis = require("periphery.ui")
local basalt = require("lib.basalt")

local DeviceController = ControllerBase:extendWithView(view)

function DeviceController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController,
		id = nil,
		deviceController = nil,
		device = nil,
		deviceType = nil,
	})
end

function DeviceController:onShow(options)
	self.id = options.id
	self.view.label:setText(options.label or ("Device " .. options.id))

	if self.deviceController ~= nil then
		self.view.content:removeChildren()
	end

	self.device = self.app.periphery:get(options.id)
	if not self.device then
		basalt.debug("no device for " .. options.id)
		return
	end

	self.deviceType = self.app.periphery:getVirtualPeripheralType(self.device)
	if not self.deviceType then
		basalt.debug("no device type for " .. self.device:getId())
		return
	end

	local UIController = peripheryUis[self.deviceType.name]
	if not UIController then
		basalt.debug("no ui controller for " .. self.deviceType.name)
		return
	end

	self.deviceController = UIController
		:new(self.view.content, self, self.device)
end

function DeviceController:back()
	self.app:changeScreen("devices")
end

function DeviceController:settings()
	self:back()
end

return DeviceController
