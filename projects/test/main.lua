local RemotePeripheryNetwork = require("periphery.server.RemotePeripheryNetwork")

local periphery = RemotePeripheryNetwork:new()

for i, peripheralType in pairs(periphery:listUnclaimedPeripherals()) do
	print(peripheralType)
end

local chestNetwork1 = periphery:get("0.75000560687785310.05")
local ioChest = periphery:get("0.446582618074833357.3")

-- TODO: This remote call is returning not found, is the ID not being passed correctly?
print(textutils.serialize(ioChest:list()))
ioChest:intake(chestNetwork1)
