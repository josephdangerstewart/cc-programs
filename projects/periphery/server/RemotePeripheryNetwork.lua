local RtpClient = require("rtp.RtpClient")
local Codes     = require("rtp.Codes")

local RemotePeripheryNetwork = {}
local RemoteVirtualPeripheral = { isRemotePeripheral = true }

function RemoteVirtualPeripheral:new(id)
	local instance = { __virtualPeripheralId = id }
	setmetatable(instance, { __index = RemoteVirtualPeripheral })
	return instance
end

function RemotePeripheryNetwork:new()
	local instance = {}
	setmetatable(instance, { __index = RemotePeripheryNetwork })
	return instance
end

local function hydrateVirtualPeripherals(obj)
	local result = {}
	for key, value in pairs(obj) do
		if type(value) == "table" and value.__virtualPeripheralId then
			result[key] = RemoteVirtualPeripheral:new(value.__virtualPeripheralId)
		elseif type(value) == "table" then
			result[key] = hydrateVirtualPeripherals(value)
		else
			result[key] = value
		end
	end
	return result
end

local client = RtpClient:new()

setmetatable(RemotePeripheryNetwork, {
	__index = function (t, key)
		return function(_self, ...)
			local code, result = client:fetch("peripheryServer", "callPeripheryNetworkMethod", {
				method = key,
				parameters = {...},
			})

			if code ~= Codes.Success then
				error("Success expected, got "..code..": "..result.err.."\n"..debug.traceback())
				return
			end

			return table.unpack(hydrateVirtualPeripherals(result or {}))
		end
	end
})

setmetatable(RemoteVirtualPeripheral, {
	__index = function(t, key)
		return function(_self, ...)
			local id = rawget(_self, "__virtualPeripheralId")
			local code, result = client:fetch("peripheryServer", "callPeripheralMethod", {
				id = id,
				method = key,
				parameters = {...},
			})

			if code ~= Codes.Success then
				error("Success expected, got "..code..": "..(result.err or "").."\n"..debug.traceback())
				return
			end

			return table.unpack(hydrateVirtualPeripherals(result or {}))
		end
	end
})

return RemotePeripheryNetwork
