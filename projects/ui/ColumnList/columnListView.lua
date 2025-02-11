local HorizontalScrollingFrameController = require("ui.HorizontalScrollingFrame")

return function(owningFrame, controller)
	local scrollingFrame = HorizontalScrollingFrameController:new(owningFrame)
	return {
		scrollingFrame = scrollingFrame,
		rootElement = scrollingFrame,
	}
end
