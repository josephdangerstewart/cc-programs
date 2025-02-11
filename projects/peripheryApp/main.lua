local AppController = require("peripheryApp.AppController")
local DevicesController = require("peripheryApp.screens.devices")
local NewDeviceController = require("peripheryApp.screens.newDevice")
local DeviceController = require("peripheryApp.screens.device")

local app = AppController:new()

app:registerScreen(DevicesController, "devices")
app:registerScreen(NewDeviceController, "newDevice")
app:registerScreen(DeviceController, "device")

app:startApp()
