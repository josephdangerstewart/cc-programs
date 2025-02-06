local Classy = require("classy.Classy")
local Codes = require("rtp.Codes")
local BackgroundWorker = require("backgroundWorker.BackgroundWorker")

local RtpServer = Classy:extend()

function RtpServer:init(options)
	self.super:init()
	options = options or {}

	for i,p in pairs(peripheral.getNames()) do
		if peripheral.getType(p) == "modem" then
			rednet.open(p)
			break
		end
	end

	local _self = self
	self:initProperties({
		routes = {},
		listeners = {},
		requestWorker = BackgroundWorker:new(function(...)
			_self:_handleRequest(unpack(arg))
		end),
		logLevel = options.logLevel or "error"
	})
end

function RtpServer:defineRoute(name, handler)
	assert(self.routes[name] == nil, "route "..name.." is already defined")
	self.routes[name] = handler
end

function RtpServer:listen(hostname)
	parallel.waitForAny(
		self:_runListener(hostname),
		self:_runPollForSockets(),
		self.requestWorker:getWorker()
	)
end

function RtpServer:broadcast(message)
	for i,id in pairs(self.listeners) do
		rednet.send(id, { message = message }, "rtp:socketMessage")
		local responseId, responseMessage

		repeat
			responseId, responseMessage = rednet.receive("rtp:socketAck", 0.5)
		until responseId == nil or responseId == id

		if responseMessage ~= "ack" then
			rednet.send(id, "close", "rtp:socketMessage")
			self:_log("removing " .. id .. " from listeners")
			table.remove(self.listeners, i)
			error("no ack received from broadcast")
		end
	end
end

function RtpServer:_runListener(hostname)
	local _self = self
	if hostname then
		local existing = rednet.lookup("rtp", hostname)
		assert(existing == nil or existing == os.getComputerID(), "Hostname "..hostname.." already in use")
		rednet.host("rtp", hostname)
	end

	return function()
		print("Listening on "..os.getComputerID()..(hostname and " host = "..hostname or ""))
		while true do
			local id, message = rednet.receive("rtp:request")
			self.requestWorker:queueWork(id, message)
		end
	end
end

function RtpServer:_handleRequest(id, message)
	if type(message) ~= "table" then
		self:_log("malformed request from "..id, "warning")
		self:_sendResponse(id, Codes.BadRequest, { err = "Message must be table" })
	elseif not message.requestId then
		self:_log("no request id from "..id, "warning")
		self:_sendResponse(id, Codes.BadRequest, { err = "message.requestId is missing" })
	elseif not message.name then
		self:_log("no name from "..id, "warning")
		self:_sendResponse(id, Codes.BadRequest, { err = "message.name is missing" }, message.requestId)
	else
		self:_log(id .. ": " .. message.name, "verbose")
		self:_handleIncomingMessage(id, message.name, message.body, message.requestId)
	end
end

function RtpServer:_runPollForSockets()
	local _self = self
	return function()
		while true do
			local id, message = rednet.receive("rtp:socketControl")
			if message == "open" then
				_self.listeners[id] = id
			else
				_self.listeners[id] = nil
			end
			rednet.send(id, "ack", "rtp:socketAck")
		end
	end
end

function RtpServer:_handleIncomingMessage(sourceId, name, body, requestId)
	if not self.routes[name] then
		self:_log("route not found " .. name, "warning")
		self:_sendResponse(sourceId, Codes.NotFound, requestId)
		return
	end

	local status, result, code = pcall(function() return self.routes[name](body) end)

	if not status then
		self:_log(result, "error")
		self:_sendResponse(sourceId, Codes.Error, { err = result }, requestId)
		return
	end

	code = code or Codes.Success
	self:_log(name.." returned "..code, "verbose")
	self:_sendResponse(sourceId, code, result, requestId)
end

function RtpServer:_sendResponse(id, code, body, requestId)
	rednet.send(id, {
		code = code,
		body = body,
		requestId = requestId,
	}, "rtp:response")
end

function RtpServer:_log(message, level)
	local levelMap = {
		error = 1,
		warning = 2,
		verbose = 3,
	}

	local messageLevel = levelMap[level]
	local loggingLevel = levelMap[self.logLevel]

	if messageLevel == nil or loggingLevel == nil or loggingLevel > messageLevel then
		return
	end

	print("["..level.."] "..message)
end

return RtpServer
