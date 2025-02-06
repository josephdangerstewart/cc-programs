local basalt = require("lib.basalt") --> Load the Basalt framework into the variable called "basalt"
local TestController = require("test.app.TestController")

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible. (you don't need to use :show())
local main = basalt.createFrame()

TestController:new(main)

basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen to any incoming events (and draw if necessary)
