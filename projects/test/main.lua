local ChestNetwork = require("periphery.types.ChestNetwork")

local network1 = ChestNetwork:new({"minecraft:chest_0", "minecraft:chest_1"})
local network2 = ChestNetwork:new({"minecraft:chest_2", "minecraft:chest_3"})

print(textutils.serialise(network1:list()))
network2:output("minecraft:oak_log", 3, network1)
