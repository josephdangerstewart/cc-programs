local FrameControllerBase = require("mvc.FrameControllerBase")
local horizontalScrollingFrameView = require("ui.HorizontalScrollingFrame.horizontalScrollingFrameView")

local HorizontalScrollingFrameController = FrameControllerBase:extendWithView(horizontalScrollingFrameView)

function HorizontalScrollingFrameController:init(owningFrame)
	self.super:init(owningFrame)

	self:initProperties({
		scrollWidth = 0,
		objects = {},
		isPaused = false,
	})
end

--[[ Public methods ]]
function HorizontalScrollingFrameController:pauseAutoScroll()
	self.isPaused = true
end

function HorizontalScrollingFrameController:resumeAutoScroll()
	self.isPaused = false
	self:calculateScrollWidth()
end

function HorizontalScrollingFrameController:calculateScrollWidth()
	if self.isPaused then
		return
	end

	local frameWidth = self.contentFrame:getSize()
	local maxScroll = 0
	for i,obj in ipairs(self.objects) do
		local objX = obj:getPosition()
		local objWidth = obj:getSize()

		local rightEdge = objX + objWidth
		maxScroll = math.max(rightEdge, maxScroll)
	end
	self.scrollWidth = maxScroll

	if self.scrollWidth > frameWidth then
		self.view.scrollbar:show()
		self.view.scrollbar:setMaxValue(self.scrollWidth - frameWidth)
	else
		self.view.scrollbar:hide()
	end
end

function HorizontalScrollingFrameController:hasScrollbar()
	local frameWidth = self.contentFrame:getWidth()
	return self.scrollWidth > frameWidth
end

--[[ View methods ]]
function HorizontalScrollingFrameController:matchScrollFrameToScrollbar()
	local index = self.view.scrollbar:getIndex()
	local value = math.floor(self.view.scrollbar:getValue() + 0.5)
	self.contentFrame:setOffset(value, 0)
end

function HorizontalScrollingFrameController:matchScrollbarToScrollFrame(dir)
	local frameWidth = self.contentFrame:getWidth()
	if not self:hasScrollbar() then
		return
	end

	local xOffset = self.contentFrame:getOffset()

	if
		xOffset + dir >= 0 and
		xOffset + dir <= self.scrollWidth - frameWidth
	then
		self.contentFrame:setOffset(xOffset+dir, 0)

		local scrollbarWidth = self.view.scrollbar:getSize()
		local percentDone = (xOffset + dir) / (self.scrollWidth - frameWidth)
		self.view.scrollbar:setIndex(math.floor(scrollbarWidth * percentDone))
	end
end

function HorizontalScrollingFrameController:onAddObject(object)
	table.insert(self.objects, object)
	self:calculateScrollWidth()
	object:onResize(
		function()
			self:calculateScrollWidth()
		end
	)
end

function HorizontalScrollingFrameController:onRemoveObject(object)
	local index = nil;
	for i,v in ipairs(self.objects) do
		if v == object then
			index = i
		end
	end
	if index ~= nil then
		table.remove(self.objects, index)
	end
end

return HorizontalScrollingFrameController
