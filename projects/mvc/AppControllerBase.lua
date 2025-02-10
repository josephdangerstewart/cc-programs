local basalt = require("lib.basalt")
local ControllerBase = require("mvc.ControllerBase")
local appView = require("mvc.appView")

local AppController = ControllerBase:extendWithView(appView)

function AppController:init()
	local rootFrame = basalt.createFrame()

	self.super:init(rootFrame)

	self:initProperties({
		rootFrame = self.view.rootFrame,
		navMenuIndexes = {}
	})
end

function AppController:debug(message)
	basalt.debug(message)
end

function AppController:navMenuChanged()
	local navItem = self.view.navMenu:getItem(
		self.view.navMenu:getItemIndex()
	)
	self:changeScreen(navItem.args[1], navItem.args[2])
end

function AppController:onChangeScreen(controller, screenName)
	if type(self.navMenuIndexes[screenName]) == "number" then
		self.view.navMenu:selectItem(self.navMenuIndexes[screenName].navMenuIndex, false)
	end
end

function AppController:onRegisterScreen(controller, screenName)
	if controller.getNavButton then
		local button = controller:getNavButton()

		self.view.navMenu:addItem(
			button.text or screenName,
			nil,
			colors.lightGray,
			screenName,
			button.args
		)
		self.navMenuIndexes[screenName] = self.view.navMenu:getItemCount()
	end
end

function AppController:stopApp()
	basalt.stop()
end

return AppController
