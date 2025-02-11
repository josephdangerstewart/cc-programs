local AppControllerBase = require("mvc.AppControllerBase")
local RemotePeripheryNetwork = require("periphery.server.RemotePeripheryNetwork")

local AppController = AppControllerBase:extend()

function AppController:init()
	self.super:init()

	local periphery = RemotePeripheryNetwork:new()

	self:initProperties({
		periphery = periphery,
	})
end

return AppController
