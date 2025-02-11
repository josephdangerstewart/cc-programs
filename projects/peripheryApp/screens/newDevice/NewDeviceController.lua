local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.newDevice.newDeviceView")

local NewDeviceController = ControllerBase:extendWithView(view)

return NewDeviceController
