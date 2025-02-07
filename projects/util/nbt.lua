local stringUtil = require("util.string")

return {
	parseName = function(rawName)
		local parts = stringUtil.split(rawName, ":")

		local source = stringUtil.formatSnakeCase(parts[1])
		local itemName = stringUtil.formatSnakeCase(parts[2])

		return {
			source = source,
			itemName = itemName,
		}
	end
}
