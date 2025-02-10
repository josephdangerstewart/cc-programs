local PeripheryServer = require("periphery.server.PeripheryServer")
local StorageChestNetwork = require("periphery.types.StorageChestNetwork")
local IOChest = require("periphery.types.IOChest")

local server = PeripheryServer:new(StorageChestNetwork, IOChest)

server:start()
