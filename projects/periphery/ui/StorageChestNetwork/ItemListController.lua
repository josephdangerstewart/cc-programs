local ControllerBase = require("mvc.ControllerBase")
local view = require("periphery.ui.StorageChestNetwork.itemListView")
local basalt = require("lib.basalt")

local ItemListController = ControllerBase:extendWithView(view)

function ItemListController:init(owningFrame, storageController)
	self.super:init(owningFrame)

	self:initProperties({
		storageController = storageController,
	})
end

function ItemListController:onSelect(item)
	basalt.debug(item)
end

function ItemListController:onShow()
	self:refresh()
end

function ItemListController:refresh(force)
	local items = self.storageController.device:list(force)

	local results = {}
	for i,item in pairs(items) do
		results[i] = {
			text = item.name,
			subText = "x" .. item.count
		}
	end

	self.view.itemList:setItems(results)
end

return ItemListController
