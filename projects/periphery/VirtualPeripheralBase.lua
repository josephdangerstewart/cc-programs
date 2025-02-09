local Classy = require("classy.Classy")

local VirtualPeripheralBase = Classy:extend({
	getPeripheralValidator = function()
		return {}
	end,
	canConstruct = function(peripherals, options)
		return true
	end,
	name = "VirtualPeripheral"
})

function VirtualPeripheralBase:init(meta)
	self.super:init()

	self:initProperties({
		meta = meta or {
			name = "Virtual Peripheral",
			description = "Please put a description of what this peripheral does"
		}
	})
end

function VirtualPeripheralBase:getMeta()
	return self.meta
end

return VirtualPeripheralBase
