local Classy = require("classy.Classy")

local VirtualPeripheralBase = Classy:extend({
	getPeripheralTypes = function()
		return {}
	end
})

function VirtualPeripheralBase:init()
	self.super:init()
end

function VirtualPeripheralBase:canAcceptPeripheral(peripheralName)
	return false
end

function VirtualPeripheralBase:acceptPeripheral(peripheralName)
end
