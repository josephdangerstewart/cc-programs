local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.devices.devicesView")
local basalt = require("lib.basalt")

local DevicesController = ControllerBase:extendWithView(view)

function DevicesController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController
	})
end

function DevicesController:getNavButton()
	return {
		text = "Devices"
	}
end

function DevicesController:onShow()
	local results = self.app.periphery:list()
	self.view.devicesContainer:removeChildren()

	for i,result in pairs(results) do
		local label = result.meta.name or ("Device " .. i)
		self.view.devicesContainer
			:addButton()
			:setText(result.meta.name or ("Device " .. i))
			:setSize(string.len(label) + 2, 3)
			:setBackground(colors.lightGray)
			:onClick(function()
				basalt.debug("new peripheral")
			end)
	end
end

function DevicesController:newDevice()
	self.app:changeScreen("newDevice")
end

return DevicesController
