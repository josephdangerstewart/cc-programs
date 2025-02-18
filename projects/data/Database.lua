local Classy = require("classy.Classy")
local stringUtil = require("util.string")
local tableUtil = require("util.table")

local function getId()
	return math.random() .. "" .. os.getComputerID() .. os.clock()
end

local Database = Classy:extend()

function Database:init(filePath)
	self.super:init()

	assert(type(filePath) == "string", "first parameter must be string")
	filePath = stringUtil.endsWith(filePath, ".db") and filePath or filePath..".db"
	self:initProperties({
		filePath = filePath,
		cachedData = nil,
	})
end

function Database:create(data)
	local id = getId()

	local fileContents = self:_getFileContents()
	fileContents.data[id] = data;

	self:_writeFileContents(fileContents)

	return id, data
end

function Database:update(id, newData)
	local fileContents = self:_getFileContents()
	if not fileContents.data[id] then
		return false, "No such record"
	end

	fileContents.data[id] = newData

	self:_writeFileContents(fileContents)

	return true
end

function Database:get(id)
	local fileContents = self:_getFileContents()
	return tableUtil.copyDeep(fileContents.data[id])
end

function Database:delete(id)
	local fileContents = self:_getFileContents()
	if not fileContents.data[id] then
		return false, "No such record"
	end

	fileContents.data[id] = nil
	self:_writeFileContents(fileContents)

	return true
end

function Database:listAll()
	return tableUtil.copyDeep(self:_getFileContents().data)
end

function Database:enumerateAll()
	return pairs(self:listAll())
end

function Database:_writeFileContents(contents)
	local file = self:_openFile("w")

	file.write(textutils.serialize(contents))
	file.close()

	if contents ~= self.cachedData then
		self.cachedData = nil
	end
end

function Database:_getFileContents()
	if self.cachedData ~= nil then
		return self.cachedData
	end

	local file = self:_openFile("r")
	local contents = textutils.unserialize(file.readAll())
	file.close()

	assert(contents.databaseVersion == "1.0.0", "invalid database file")

	self.cachedData = contents
	return contents
end

function Database:_openFile(mode)
	if not fs.exists(self.filePath) then
		local file = fs.open(self.filePath, "w")
		file.write(textutils.serialize({
			databaseVersion = "1.0.0",
			data = {}
		}))
		file.close()
	end

	local file = fs.open(self.filePath, mode)
	return file
end

return Database
