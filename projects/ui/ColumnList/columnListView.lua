local basalt = require("lib.basalt")

return function(owningFrame, controller)
	local rootElement = owningFrame
		:addFrame()
		:setBackground(colors.white)

	local scrollingFrame = rootElement
		:addScrollableFrame()

	local scrollBar = rootElement
		:addScrollbar()

	scrollingFrame
		:setDirection("horizontal")
		:setPosition(1, 1)
		:setSize("parent.w", "parent.h - 1")
		:setBackground(colors.white)
		:onScroll(function(_, _, direction)
			local index = math.max(0, math.min(controller:getScrollAmount() + 1, scrollingFrame:getOffset() + direction + 1))
			scrollBar:setIndex(index)
		end)

	scrollBar
		:setBarType("horizontal")
		:setSize("parent.w", 1)
		:setPosition(1, "parent.h")
		:onChange(function(_, _, value)
			scrollingFrame:setOffset(value - 1)
		end)

	return {
		scrollingFrame = scrollingFrame,
		rootElement = rootElement,
		scrollBar = scrollBar,
	}
end
