local Classy = require("classy.Classy")

local PeripheryNetwork = Classy:extend()

function PeripheryNetwork:init(...)
	self.super:init()

	self:initProperties({
		virtualPeripherals = {...}
	})
end

return PeripheryNetwork
