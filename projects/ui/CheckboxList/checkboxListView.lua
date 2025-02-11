return function(owningFrame)
	local rootElement = owningFrame
		:addScrollableFrame()
		:setBackground(colors.gray)
		:setSize(6, 4)

	return {
		rootElement = rootElement,
	}
end
