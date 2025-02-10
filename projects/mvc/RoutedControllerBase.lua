local ControllerBase = require("mvc.ControllerBase")

local RoutedControllerBase = ControllerBase:extend()

function RoutedControllerBase:init(owningFrame)
	self.super:init(owningFrame)

	self:initProperties({
		currentScreen = nil,
		screenArgs = {},
		allScreens = {},
		screenControllers = {},
	})
end

function RoutedControllerBase:onChangeScreen(controller, screenName)
end

function RoutedControllerBase:onRegisterScreen(controller, screenName)
end

function RoutedControllerBase:changeScreen(screen, args)
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
	
	self.currentScreen = self.allScreens[screen].frame

	self:onChangeScreen(self.allScreens[screen].controller, screen)
end

function RoutedControllerBase:registerScreen(controllerClass, screenName)
	local screenFrame = self.view.rootFrame
		:addFrame()
		:setBackground(colors.white)
	
	local controller = controllerClass:new(screenFrame, self)

	table.insert(self.screenControllers, controller)

	self.allScreens[screenName] = {
		frame = screenFrame,
		controller = controller,
	}

	self:onRegisterScreen(controller, screenName)

	screenFrame:hide()

	if self.currentScreen == nil then
		self:changeScreen(screenName)
	end

	return controller
end

return RoutedControllerBase
