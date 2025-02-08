local ChestNetwork = require("periphery.types.ChestNetwork")
local matchers = require("periphery.peripheralMatchers")

local chests = {}
for i,v in pairs(peripheral.getNames()) do
	if matchers.isMatch({peripheral.getType(v)}, ChestNetwork.getPeripheralTypes()) then
		print("adding "..v)
		table.insert(chests, v)
	end
end

local network = ChestNetwork:new(chests)

print(textutils.serialise(network:list()))
