local Classy = require("classy.Classy")

local VirtualPeripheralBase = Classy:extend({
	getPeripheralTypes = function()
		return {}
	end,
	name = "VirtualPeripheral"
})

function VirtualPeripheralBase:init(meta)
	self.super:init({
		meta = meta or {
			name = "Virtual Peripheral",
			description = "Please put a description of what this peripheral does"
		}
	})
end

function VirtualPeripheralBase:canAcceptPeripheral(peripheralName)
	return false
end

function VirtualPeripheralBase:acceptPeripheral(peripheralName)
end

function VirtualPeripheralBase:getMeta()
	return self.meta
end

function VirtualPeripheralBase:setOptions()
end

function VirtualPeripheralBase:getOptions()
	return {}
end

return VirtualPeripheralBase
