local Classy = require("classy.Classy")

local VirtualPeripheralBase = Classy:extend({
	getPeripheralValidator = function()
		return {}
	end,
	canConstruct = function(peripherals, options)
		return true
	end,
	meta = {
		name = "Virtual Peripheral",
		description = "Please put a description of what this peripheral does"
	},
	name = "VirtualPeripheral"
})

function VirtualPeripheralBase:init()
	self.super:init()
end

function VirtualPeripheralBase:setId(id)
	self.id = id
end

function VirtualPeripheralBase:getId()
	return self.id
end

function VirtualPeripheralBase:getMeta()
	return self.meta
end

return VirtualPeripheralBase
