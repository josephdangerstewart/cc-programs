local Classy = require("classy.Classy")

local ControllerBase = Classy:extend()

function ControllerBase:init(ownerPanel)
	self.super:init()

	assert(type(self.initView) == "function", "initView must be function")

	self:initProperties({
		view = self.initView(ownerPanel, self)
	})
end

function ControllerBase:extendWithView(initView)
	return self:extend({ initView = initView })
end

return ControllerBase
