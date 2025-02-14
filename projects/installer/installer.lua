-- Installs packages and dependencies from this repo

local vargs = {...}
local project = vargs[1]

local downloadProject = function() error("not loaded") end
if fs.exists("/installer/installerUtil.lua") then
	downloadProject = require("installer.installerUtil").downloadProject
else
	local response = http.get("https://api.github.com/repos/josephdangerstewart/cc-programs/contents/projects/installer/installerUtil.lua")
	local utilsContents = response.readAll()
	response.close()
	downloadProject = load(utilsContents)().downloadProject
end

downloadProject("installer")
if project then
	downloadProject(project)
end

local startupContents = [[
-- Generated code that automatically looks for updates
require("installer.autoUpdate")
]]
if fs.exists("startup.lua") then
	local file = fs.open("startup.lua", "r")
	startupContents = startupContents .. "\n\n\n" .. file.readAll()
	file.close()
end

local file = fs.open("startup.lua", "w")
file.write(startupContents)
file.close()
