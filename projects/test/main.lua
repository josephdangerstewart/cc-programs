local basalt = require("lib.basalt") --> Load the Basalt framework into the variable called "basalt"
local TestController = require("test.app.TestController")
local OtherScreenController = require("test.app.OtherScreenController")
local AppController = require("mvc.AppControllerBase")

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible. (you don't need to use :show())
local appController = AppController:new()

appController:registerScreen(TestController, "test")
appController:registerScreen(OtherScreenController, "other")

basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen to any incoming events (and draw if necessary)
