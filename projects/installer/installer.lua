-- Installs packages and dependencies from this repo

local vargs = {...}
local force = false
local positionalArgs = {}

for i, arg in pairs(vargs) do
	if arg == "--force" then
		force = true
	else
		table.insert(positionalArgs, arg)
	end
end

local project = positionalArgs[1]

local repo = "cc-programs"
local owner = "josephdangerstewart"

local pat
if fs.exists(".gh-auth") then
	local file = fs.open(".gh-auth", "r")
	pat = file.readAll()
	file.close()
else
	print("Enter GitHub access token (or leave empty for unauthed)")
	print("Note: Access token does not need permissions, it's only to avoid rate limiting")
	pat = read()

	if pat ~= "" then
		print("Save access token for future use (Y/N)? Not recommended on public servers")
		local response = string.lower(read())
		if response == "y" or response == "yes" then
			local file = fs.open(".gh-auth", "w")
			file.write(pat)
			file.close()
		end
	end
end

local function repoBaseUrl()
	return "https://api.github.com/repos/" .. owner .. "/" .. repo
end

local function rawContentBaseUrl()
	return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/master"
end

local function fetch(url)
	local headers = pat and pat ~= "" and {
		Authorization = "Bearer " .. pat
	} or nil
	local request, err, failedResponse = http.get(url, headers)
	if err then
		local code = failedResponse.getResponseCode()
		failedResponse.close()
		error(code .. ": " .. err .. "\n\n" .. debug.traceback())
	end
	local result = request.readAll()
	request.close()
	return result
end

local function fetchJson(url)
	return textutils.unserialiseJSON(fetch(url))
end

local function downloadDirectory(directoryPath)
	print("Downloading directory " .. directoryPath)
	local children = fetchJson(repoBaseUrl() .. "/contents/projects/" .. directoryPath)
	for i, v in pairs(children) do
		if v.type == "file" then
			print("Downloading file " .. v.name)
			local fileContents = fetch(v.download_url)
			local file = fs.open(directoryPath .. "/" .. v.name, "w")
			file.write(fileContents)
			file.close()
		else
			downloadDirectory(directoryPath .. "/" .. v.name)
		end
	end
end

local function getLatestCommit(projectName)
	local pathParameter = projectName and "&path=/projects/" .. projectName or ""
	return fetchJson(repoBaseUrl() .. "/commits?per_page=1" .. pathParameter)[1].sha
end

local function needsUpdate(projectName)
	if (projectName and not fs.exists(projectName)) or force then
		return true
	end

	local latestRemoteCommit = getLatestCommit(projectName)
	local filePath = (projectName or "") .. "/.last-commit"
	local latestLocalCommit

	if fs.exists(filePath) then
		local file = fs.open(filePath, "r")
		latestLocalCommit = file.readAll()
		file.close()
	end

	return latestLocalCommit ~= latestRemoteCommit, latestRemoteCommit
end

local function writeLastCommit(projectName, sha)
	local filePath = (projectName or "") .. "/.last-commit"
	local file = fs.open(filePath, "w")
	file.write(sha or getLatestCommit(projectName))
	file.close()
end

local function readLocalConfig(projectName)
	local file = fs.open(projectName .. "/config.json", "r")
	local contents = file.readAll()
	file.close()
	return textutils.unserialiseJSON(contents)
end

local processedProjects = {}

local function downloadProject(projectName)
	assert(projectName, "invalid project")

	if processedProjects[projectName] then
		return
	end
	processedProjects[projectName] = true

	local shouldUpdateProject = needsUpdate(projectName)

	local config
	if shouldUpdateProject then
		if fs.exists(projectName) then
			print("Updating " .. projectName)
			fs.delete(projectName)
		end

		print("Downloading project " .. projectName)
		config = fetchJson(rawContentBaseUrl() .. "/projects/" .. projectName .. "/config.json")
		downloadDirectory(projectName)
	else
		print("Project ".. projectName .. " is installed and up to date")
		config = readLocalConfig(projectName)
	end

	if config.dependencies then
		for i, dependency in pairs(config.dependencies) do
			downloadProject(dependency)
		end
	end

	if config.entry and shouldUpdateProject then
		local runs = config.entry.runs or "main"
		local fileName = config.entry.fileName or projectName

		local file = fs.open(fileName .. ".lua", "w")
		file.write("require(\"" .. projectName .. "." .. runs .. "\")")
	end

	writeLastCommit(projectName)
end

local remoteHasAnyChanges, baseHeadSha = needsUpdate()
if remoteHasAnyChanges or (project and not fs.exists(project)) then
	downloadProject("installer")
	if project then
		downloadProject(project)
	end
	writeLastCommit(nil, baseHeadSha)

	local startupContents = "shell.run(\"/installer/installer.lua " .. (project or "") .. "\")"
	if fs.exists("startup.lua") then
		local file = fs.open("startup.lua", "r")
		local existingStartupContents = file.readAll()
		file.close()

		if string.find(existingStartupContents, startupContents) then
			startupContents = existingStartupContents
		else
			startupContents = startupContents .. "\n\n\n" .. existingStartupContents
		end
	end

	local file = fs.open("startup.lua", "w")
	file.write(startupContents)
	file.close()
else
	print("Installer will not run, everything is up to date")
	print("Use --force to force complete reinstall")
end
