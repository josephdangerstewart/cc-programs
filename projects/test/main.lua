local basalt = require("lib.basalt") --> Load the Basalt framework into the variable called "basalt"

--> Now we want to create a base frame, we call the variable "main" - by default everything you create is visible. (you don't need to use :show())
local main = basalt.createFrame()

local button = main:addButton() --> Here we add our first button
button:setPosition(4, 4) -- We want to change the default position of our button
button:setSize(16, 3) -- And the default size.
button:setText("Click me!") --> This method sets the text displayed on our button

local function buttonClick() --> Create a function we want to call when the button gets clicked 
    basalt.debug("I got clicked!")
end

-- Now we just need to register the function to the button's onClick event handlers, this is how we can achieve that:
button:onClick(buttonClick)

basalt.autoUpdate() -- As soon as we call basalt.autoUpdate, the event and draw handlers will listen to any incoming events (and draw if necessary)
