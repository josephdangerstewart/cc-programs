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
		deviceFrame = nil,
		device = nil,
		deviceType = nil,
		cachedDeviceFrames = {},
		cachedDeviceControllers = {}
	})
end

function DeviceController:onShow(options)
	self.id = options.id
	self.view.label:setText(options.label or ("Device " .. options.id))

	if self.deviceFrame then
		self.deviceFrame:hide();
	end

	if self.deviceController and self.deviceController.onHide then
		self.deviceController:onHide()
	end

	if self.cachedDeviceFrames[options.id] then
		if self.cachedDeviceControllers[options.id] and self.cachedDeviceControllers[options.id].onShow then
			self.cachedDeviceControllers[options.id]:onShow()
		end
		self.cachedDeviceFrames[options.id]:show()
		return
	end

	self.device = self.app.periphery:get(options.id)
	if not self.device then
		return
	end

	self.deviceType = self.app.periphery:getVirtualPeripheralType(self.device)
	if not self.deviceType then
		return
	end

	local UIController = peripheryUis[self.deviceType.name]
	if not UIController then
		return
	end

	self.deviceFrame = self.view.content
		:addFrame()
		:setPosition(1, 1)
		:setSize("parent.w", "parent.h")
		:setBackground(colors.white)

	self.deviceController = UIController
		:new(self.deviceFrame, self, self.device)

	if self.deviceController.onShow then
		self.deviceController:onShow()
	end

	self.cachedDeviceControllers[options.id] = self.deviceController
	self.cachedDeviceFrames[options.id] = self.deviceFrame
end

function DeviceController:back()
	self.app:changeScreen("devices")
end

function DeviceController:settings()
	self:back()
end

return DeviceController
