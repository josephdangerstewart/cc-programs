local AppController = require("peripheryApp.AppController")
local PeripheralsScreen = require("peripheryApp.screens.peripherals")

local app = AppController:new()

app:registerScreen(PeripheralsScreen, "peripherals")

app:startApp()
