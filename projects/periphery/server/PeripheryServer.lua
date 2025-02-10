local PeripheryNetwork = require("periphery.server.PeripheryNetwork")
local VirtualPeripheralBase = require("periphery.VirtualPeripheralBase")
local RtpServer = require("rtp.RtpServer")
local Classy = require("classy.Classy")
local Codes  = require("rtp.Codes")

local PeripheryServer = Classy:extend()

function PeripheryServer:init(...)
	self.super:init()

	self:initProperties({
		server = RtpServer:new({
			logLevel = "verbose"
		}),
		periphery = PeripheryNetwork:new(...),
	})
end

function PeripheryServer:start()
	local _self = self

	self.server:defineRoute("callPeripheralMethod", function(request)
		local id = request.id
		local method = request.method
		local parameters = self:_hydrateVirtualPeripherals(request.parameters or {})

		local vPeripheral = _self.periphery:get(id)

		if not vPeripheral then
			return "No such peripheral", Codes.NotFound
		end

		if not vPeripheral[method] then
			return "No such method", Codes.NotFound
		end

		local result = {vPeripheral[method](vPeripheral, table.unpack(parameters or {}))}
		return _self:_serializeVirtualPeripherals(result)
	end)

	self.server:defineRoute("callPeripheryNetworkMethod", function(request)
		local method = request.method
		local parameters = self:_hydrateVirtualPeripherals(request.parameters or {})

		if not _self.periphery[method] then
			return "No such  method", Codes.NotFound
		end

		local result = {_self.periphery[method](_self.periphery, table.unpack(parameters or {}))}
		return _self:_serializeVirtualPeripherals(result)
	end)

	print("starting listener on peripheryServer")
	self.server:listen("peripheryServer")
end

function PeripheryServer:_hydrateVirtualPeripherals(obj)
	local result = {}
	for key, value in pairs(obj) do
		if type(value) == "table" and value.__virtualPeripheralId then
			result[key] = self.periphery:get(value.__virtualPeripheralId)
		elseif type(value) == "table" and value.__virtualPeripheralClass then
			result[key] = self.periphery:getVirtualPeripheralType(value.__virtualPeripheralClass)
		elseif type(value) == "table" then
			result[key] = self:_hydrateVirtualPeripherals(value)
		else
			result[key] = value
		end
	end
	return result
end

function PeripheryServer:_serializeVirtualPeripherals(obj)
	local result = {}
	for key, value in pairs(obj) do
		if type(value) == "table" and Classy:isInstance(value) and value:isType(VirtualPeripheralBase) then
			result[key] = { __virtualPeripheralId = value:getId() }
		elseif type(value) == "table" and Classy:isClass(value) and value:isType(VirtualPeripheralBase) then
			result[key] = { __virtualPeripheralClass = value.name, meta = value.meta, name = value.name }
		elseif type(value) == "table" then
			result[key] = self:_serializeVirtualPeripherals(value)
		else
			result[key] = value
		end
	end
	return result
end

return PeripheryServer
