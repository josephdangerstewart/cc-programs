local repo = "cc-programs"
local owner = "josephdangerstewart"

local function repoBaseUrl()
	return "https://api.github.com/repos/" .. owner .. "/" .. repo
end

local function rawContentBaseUrl()
	return "https://raw.githubusercontent.com/" .. owner .. "/" .. repo .. "/master"
end

local function fetch(url)
	local request, err, failedResponse = http.get(url)
	if err then
		local code = failedResponse.getResponseCode()
		failedResponse.close()
		error(code .. ": " .. err)
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

local processedProjects = {}

local function downloadProject(projectName)
	if processedProjects[projectName] then
		return
	end
	processedProjects[projectName] = true

	print("Downloading project " .. projectName)
	local config = fetchJson(rawContentBaseUrl() .. "/projects/" .. projectName .. "/config.json")
	downloadDirectory(projectName)

	if config.dependencies then
		for i, dependency in pairs(config.dependencies) do
			downloadProject(dependency)
		end
	end

	if config.entry then
		local runs = config.entry.runs or "main"
		local fileName = config.entry.fileName or projectName

		local file = fs.open(fileName .. ".lua", "w")
		file.write("require(\"" .. projectName .. "." .. runs .. "\")")
	end

	local commit = fetchJson(repoBaseUrl() .. "/commits?per_page=1&path=/projects/" .. projectName)[1].sha
	local file = fs.open("/" .. projectName .. "/.last-commit", "w")
	file.write(commit)
	file.close()
end

return {
	downloadProject = downloadProject
}
