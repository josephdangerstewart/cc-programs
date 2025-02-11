local RoutedControllerBase = require("mvc.RoutedControllerBase")
local view = require("mvc.routedControllerView")

local RoutedController = RoutedControllerBase:extendWithView(view)

return RoutedController
