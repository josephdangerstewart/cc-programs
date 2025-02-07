local ChestNetwork = require("periphery.types.ChestNetwork")
local matchers = require("periphery.peripheralMatchers")

local chest = "minecraft:chest_0"

print(matchers.isMatch({peripheral.getType(chest)}, ChestNetwork.getPeripheralTypes()))
local network = ChestNetwork:new({chest})

for i,v in pairs(peripheral.getNames()) do
	print("can accept " .. v .. "?", network:canAcceptPeripheral(v))
end

print(textutils.serialise(network:list()))
