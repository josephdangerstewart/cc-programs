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
	self.deviceId = options.device:getId()

	local meta = self.app.periphery:getDeviceMeta(self.deviceId)
	self.view.titleLabel:setText(meta and meta.name or "Device Settings")

	self:_populatePeripheralsLists()
end

function DeviceSettingsController:back()
	self.app:changeScreen("device", { id = self.deviceId })
end

function DeviceSettingsController:delete()
	self.app.periphery:delete(self.deviceId)
	self.app:changeScreen("devices")
end

function DeviceSettingsController:addPeripherals()
	local selected = self.view.unclaimedPeripheralsList:getValue()
	local peripherals = {}
	for i,v in pairs(selected) do
		table.insert(peripherals, v.text)
	end

	if #peripherals > 0 then
		self.app.periphery:addPeripherals(self.deviceId, peripherals)
	end

	self:_populatePeripheralsLists()
end

function DeviceSettingsController:removePeripherals()
	local selected = self.view.attachedPeripheralsList:getValue()
	local peripherals = {}
	for i,v in pairs(selected) do
		table.insert(peripherals, v.text)
	end

	if #peripherals > 0 then
		self.app.periphery:removePeripherals(self.deviceId, peripherals)
	end

	self:_populatePeripheralsLists()
end

function DeviceSettingsController:_populatePeripheralsLists()
	self.view.unclaimedPeripheralsList:clear()
	self.view.attachedPeripheralsList:clear()

	local deviceMeta, deviceType = self.app.periphery:getDeviceMeta(self.deviceId)

	local unclaimedPeripherals = self.app.periphery:listUnclaimedPeripherals(deviceType)
	local attachedPeripherals = self.app.periphery:listAttachedPeripherals(self.deviceId)

	for i, p in pairs(unclaimedPeripherals) do
		self.view.unclaimedPeripheralsList:addItem({
			text = p,
		})
	end

	for i, p in pairs(attachedPeripherals) do
		self.view.attachedPeripheralsList:addItem({
			text = p,
		})
	end
end

return DeviceSettingsController
