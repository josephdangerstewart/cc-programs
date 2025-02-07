local basalt = require("lib.basalt")
local ControllerBase = require("mvc.ControllerBase")
local appView = require("mvc.appView")

local AppController = ControllerBase:extendWithView(appView)

function AppController:init()
	local rootFrame = basalt.createFrame()

	self.super:init(rootFrame)

	self:initProperties({
		rootFrame = self.view.rootFrame,
		currentScreen = nil,
		screenArgs = {},
		allScreens = {},
		screenControllers = {},
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

function AppController:changeScreen(screen, args)
	if self.allScreens[screen] == nil then
		return false, "No such screen"
	end

	self.screenArgs = args

	if self.currentScreen ~= nil then
		self.currentScreen:hide()
	end

	self.allScreens[screen].frame:show()

	if self.allScreens[screen].controller.onShow ~= nil then
		self.allScreens[screen].controller:onShow(args)
	end
	
	self.view.navMenu:selectItem(self.allScreens[screen].navMenuIndex, false)

	self.currentScreen = self.allScreens[screen].frame
end

function AppController:registerScreen(controllerClass, screenName)
	local screenFrame = self.view.rootFrame
		:addFrame()
		:setBackground(colors.white)
	
	local controller = controllerClass:new(screenFrame, self)

	table.insert(self.screenControllers, controller)

	local navMenuIndex = nil
	if controller.getNavButton then
		local button = controller:getNavButton()

		self.view.navMenu:addItem(
			button.text or screenName,
			nil,
			colors.lightGray,
			screenName,
			button.args
		)
		navMenuIndex = self.view.navMenu:getItemCount()
	end

	self.allScreens[screenName] = {
		frame = screenFrame,
		controller = controller,
		navMenuIndex = navMenuIndex,
	}

	screenFrame:hide()

	if self.currentScreen == nil then
		self:changeScreen(screenName)
	end

	return controller
end

function AppController:stopApp()
	basalt.stop()
end

return AppController
