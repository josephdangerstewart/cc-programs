local basaltUtil = require("ui.basaltUtil")

return function(owningFrame, controller)
	local container = owningFrame:addFrame()

	local scrollingFrame = container
		:addFrame()
		:setSize("parent.w", "parent.h - 1")
		:setPosition(1, 1)
		:onScroll(function(a, b, dir)
			controller:matchScrollbarToScrollFrame(dir)
		end)
		:setBackground(colors.white)
	
	local scrollbar = container
		:addScrollbar()
		:setBarType("horizontal")
		:setPosition(1, "parent.h")
		:setMaxValue(20)
		:setSize("parent.w", 1)
		:onChange(function()
			controller:matchScrollFrameToScrollbar()
		end)
		:hide()

	return {
		contentFrame = basaltUtil.wrapFrameWithChildrenObserver(
			scrollingFrame,
			function(obj)
				controller:onAddObject(obj)
			end,
			function(obj)
				controller:onRemoveObject(obj)
			end
		),
		scrollbar = scrollbar,
		rootFrame = container,
	}
end
