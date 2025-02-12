return function(owningFrame)
	local scrollingFrame = owningFrame
		:addScrollableFrame()
		:setBackground(colors.white)

	return {
		scrollingFrame = scrollingFrame,
		rootElement = scrollingFrame,
	}
end
