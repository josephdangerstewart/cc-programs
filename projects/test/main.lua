local PeripheryNetwork = require("periphery.server.PeripheryNetwork")
local ChestNetwork = require("periphery.types.ChestNetwork")

local periphery = PeripheryNetwork:new(ChestNetwork)

for i, peripheralType in pairs(periphery:listVirtualPeripheralTypes()) do
	print(peripheralType.meta.name)
end
