local basalt = require("lib.basalt")
local RoutedControllerBase = require("mvc.RoutedControllerBase")
local appView = require("mvc.appView")

local AppController = RoutedControllerBase:extendWithView(appView)

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
		self.view.navMenu:selectItem(self.navMenuIndexes[screenName], false)
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

function AppController:startApp()
	basalt.autoUpdate()
end

return AppController
