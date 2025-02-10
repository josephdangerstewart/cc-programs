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

function VirtualPeripheralBase:init(meta)
	self.super:init()

	self:initProperties()
end

function VirtualPeripheralBase:getMeta()
	return self.meta
end

return VirtualPeripheralBase
