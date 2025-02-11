local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.newDevice.newDeviceView")

local NewDeviceController = ControllerBase:extendWithView(view)

function NewDeviceController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController,
		deviceKinds = {}
	})
end

function NewDeviceController:onShow()
	self:resetForm()
end

function NewDeviceController:handleFormChange()
	self:_validateButton()
end

function NewDeviceController:handleKindChange()
	self:_setPeripheralOptions()
	self:handleFormChange()
end

function NewDeviceController:handleSubmit()
	if not self:_isFormValid() then
		return
	end

	local peripherals = {}
	for i,v in pairs(self.view.peripheralsList:getValue()) do
		table.insert(peripherals, v.text)
	end

	self.app.periphery:create(self:_getDeviceKind(), peripherals, nil, { name = self.view.nameInput:getValue() })
	self:back()
end

function NewDeviceController:back()
	self.app:changeScreen("devices")
end

function NewDeviceController:resetForm()
	self.view.nameInput:setValue("")
	self:_setDeviceKindOptions()
	self:_setPeripheralOptions()
	self:_validateButton()
end

function NewDeviceController:_setDeviceKindOptions()
	self.deviceKinds = self.app.periphery:listVirtualPeripheralTypes()

	self.view.kindDropdown:clear()
	for i, deviceKind in pairs(self.deviceKinds) do
		self.view.kindDropdown:addItem(deviceKind.meta.name or "Device")
	end
end

function NewDeviceController:_setPeripheralOptions()
	self.view.peripheralsList:clear()

	local deviceKind = self:_getDeviceKind()

	if not deviceKind then
		return
	end

	local unclaimedPeripherals = self.app.periphery:listUnclaimedPeripherals(deviceKind)

	for i, unclaimedPeripheral in pairs(unclaimedPeripherals) do
		self.view.peripheralsList:addItem({
			text = unclaimedPeripheral
		})
	end
end

function NewDeviceController:_validateButton()
	if not self:_isFormValid() then
		self.view.submitButton:setBackground(colors.lightGray)
	else
		self.view.submitButton:setBackground(colors.green)
	end
end

function NewDeviceController:_isFormValid()
	local nameValue = self.view.nameInput:getValue()
	local peripherals = self.view.peripheralsList:getValue()
	
	return string.len(nameValue) > 0 and #peripherals > 0 and #self.deviceKinds > 0
end

function NewDeviceController:_getDeviceKind()
	local selectedDeviceIndex = self.view.kindDropdown:getItemIndex()
	return self.deviceKinds[selectedDeviceIndex]
end

return NewDeviceController
