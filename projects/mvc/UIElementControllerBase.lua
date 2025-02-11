local ControllerBase = require("mvc.ControllerBase")

local UIElementControllerBase = ControllerBase:extend()

function UIElementControllerBase:init(owningPanel)
	self.super:init(owningPanel)

	assert(self.view.rootElement ~= nil, "UIElementControllerBase must defined rootElement")
	
	self:initProperties({
		rootElement = self.view.rootElement
	})
end

function UIElementControllerBase:setPosition(x, y)
	self.rootElement:setPosition(x, y)
	return self
end

function UIElementControllerBase:getPosition()
	return self.rootElement:getPosition()
end

function UIElementControllerBase:getSize()
	return self.rootElement:getSize()
end

function UIElementControllerBase:setSize(w, h)
	self.rootElement:setSize(w, h)
	return self
end

function UIElementControllerBase:setBackground(color)
	self.rootElement:setBackground(color)
	return self
end

return UIElementControllerBase
