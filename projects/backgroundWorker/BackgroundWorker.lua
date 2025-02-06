local Classy = require("classy.Classy")

local BackgroundWorker = Classy:extend()

function BackgroundWorker:init(doWork)
	self.super:init()

	self.super:initProperties({
		queue = {},
		doWork = doWork,
	})
end

function BackgroundWorker:getWorker()
	local _self = self
	return function()
		while true do
			if #_self.queue > 0 then
				local workItem = _self.queue[1]
				table.remove(_self.queue, 1)
				_self.doWork(unpack(workItem))
			else
				sleep(0.05)
			end
		end
	end
end

function BackgroundWorker:queueWork(...)
	table.insert(self.queue, arg)
end

return BackgroundWorker
