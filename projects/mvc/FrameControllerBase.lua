local ControllerBase = require("mvc.ControllerBase")
local stringUtil = require("util.string")

local FrameControllerBase = ControllerBase:extend()

function FrameControllerBase:init(owningPanel)
	self.super:init(owningPanel)

	assert(self.view.contentFrame ~= nil, "FrameControllerView must defined contentFrame")

	self:initProperties({
		contentFrame = self.view.contentFrame,
		rootFrame = self.view.rootFrame or self.view.contentFrame,
	})
end

function FrameControllerBase:setPosition(x, y)
	self.rootFrame:setPosition(x, y)
	return self
end

function FrameControllerBase:getPosition()
	return self.rootFrame:getPosition()
end

function FrameControllerBase:getSize()
	return self.rootFrame:getSize()
end

function FrameControllerBase:setSize(w, h)
	self.rootFrame:setSize(w, h)
	return self
end

function FrameControllerBase:getContentSize()
	return self.contentFrame:getSize()
end

function FrameControllerBase:__index(key)
	local contentFrame = self.contentFrame
	local _self = self
	if (stringUtil.startsWith(key, "add") or key == "removeObject") and contentFrame[key] then
		return function(firstParam, ...)
			return contentFrame[key](contentFrame, ...)
		end
	end

	if type(contentFrame[key]) == "function" then
		return function(firstParam, ...)
			local result = contentFrame[key](contentFrame, ...)
			if result == contentFrame then
				return _self
			end
			return result
		end
	end
end

return FrameControllerBase
