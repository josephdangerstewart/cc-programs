local PeripheryNetwork = require("periphery.server.PeripheryNetwork")
local ChestNetwork = require("periphery.types.ChestNetwork")

local periphery = PeripheryNetwork:new(ChestNetwork)
print(ChestNetwork.name)

local network1 = periphery:get("0.8801274637736410.05")

print(network1)

print(textutils.serialize(periphery:listUnclaimedPeripherals()))
