local ControllerBase = require("mvc.ControllerBase")
local view = require("peripheryApp.screens.peripherals.peirpheralsView")
local basalt = require("lib.basalt")

local PeripheralsController = ControllerBase:extendWithView(view)

function PeripheralsController:init(owningFrame, appController)
	self.super:init(owningFrame)

	self:initProperties({
		app = appController
	})
end

function PeripheralsController:onShow()
	local results = self.app.periphery:list()
	self.view.peripheralsContainer:removeChildren()

	for i,result in pairs(results) do
		local label = result.meta.name or ("Device " .. i)
		self.view.peripheralsContainer
			:addButton()
			:setText(result.meta.name or ("Device " .. i))
			:setSize(string.len(label) + 2, 3)
			:onClick(function()
				basalt.debug("new peripheral")
			end)
	end
end

function PeripheralsController:newPeripheral()
	basalt.debug("new peripheral")
end

return PeripheralsController
