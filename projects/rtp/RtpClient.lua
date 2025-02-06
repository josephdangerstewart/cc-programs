local Classy = require("classy.Classy")
local Codes = require("rtp.Codes")
local BackgroundWorker = require("BackgroundWorker")

local RtpClient = Classy:extend()

function RtpClient:init(options)
	self.super:init()
	options = options or {}

	for i,p in pairs(peripheral.getNames()) do
		if peripheral.getType(p) == "modem" then
			rednet.open(p)
			break
		end
	end

	self:initProperties({
		timeout = options.timeout or 30,
		requestId = 0,
	})
end

function RtpClient:pollServerMessages(idOrHost, onMessageReceived)
	local worker = BackgroundWorker:new(onMessageReceived)
	parallel.waitForAny(
		self:_runReceiveServerMessages(idOrHost, worker),
		worker:getWorker()
	)
end

function RtpClient:fetch(idOrHost, routeName, body)
	local id, failureCode, failureMessage = self:_resolveId(idOrHost)
	if failureCode then
		return failureCode, { err = failureMessage }
	end

	self.requestId = self.requestId + 1
	local requestId = self.requestId
	rednet.send(id, { name = routeName, body = body, requestId = requestId }, "rtp:request")
	return self:_pollResponse(id, requestId)
end

function RtpClient:_runReceiveServerMessages(idOrHost, messageWorker)
	local _self = self
	local id, failureCode, failureMessage = _self:_resolveId(idOrHost)
	assert(failureCode == nil, failureMessage)
	
	rednet.send(id, "open", "rtp:socketControl")
	assert(self:_pollSocketAck(id), "Failed to open socket")

	return function()
		while true do
			local requestId, message = rednet.receive("rtp:socketMessage")

			if message == "close" then
				return
			end

			assert(message ~= "open", "unexpected open socket message")
			assert(message ~= "ack", "unexpected ack message")
			assert(type(message) == "table", "malformed message")

			if requestId == id then
				messageWorker:queueWork(message.message)
				rednet.send(requestId, "ack", "rtp:socketAck")
			end
		end
	end
end

function RtpClient:_pollResponse(id, requestId)
	local responseId, response
	repeat
		responseId, response = rednet.receive("rtp:response", self.timeout)
	until  responseId == nil or (responseId == id and response and response.requestId == requestId)

	if responseId == nil then
		return Codes.ClientTimeout, { err = "The operation timed out" }
	end

	return response.code, response.body
end

function RtpClient:_pollSocketAck(id)
	local responseId, response
	repeat
		responseId, response = rednet.receive("rtp:socketAck", self.timeout)
	until responseId == id or responseId == nil

	return response == "ack"
end

function RtpClient:_resolveId(idOrHost)
	local id = idOrHost
	if type(idOrHost) == "string" then
		ids = {rednet.lookup("rtp", idOrHost)}
		if #ids == 0 then
			return nil, Codes.NotFound, "Host not resolved"
		elseif #ids > 1 then
			return nil, Codes.NotFound, "Multiple hosts resolved"
		end
		id = ids[1]
	end
	if type(id) ~= "number" then
		return nil, Codes.BadRequest, "Bad id or host"
	end
	return id
end

return RtpClient
