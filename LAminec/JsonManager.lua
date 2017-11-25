require("json")
require("lfs")

require("LAminec.class")

require("LAminec.utility")
require("LAminec.info")

--It is a class which manage all infomations in version.json
JsonManager = class()

--constructor of JsonManager
function JsonManager:ctor(version)

	local jsonFilePath = info.corePath.."/versions/"..version.."/"..version..".json"
	local jsonFile, err = io.open(jsonFilePath, "r")
	
	if jsonFile == nil then
		print(err)
		return
	end
	
	local content = jsonFile:read("*a")
	jsonFile:close()
	
	self.json = json.decode(content)
end

function JsonManager:getClassPaths()
	
	local filePaths = ""
	for k, c in pairs(self.json.libraries) do
		local downloads = c.downloads
		if downloads ~= nil then
			local artifact = downloads.artifact
			if artifact ~= nil then
				local path = artifact.path
				if path ~= nil then
					filePaths = filePaths..info.corePath.."/libraries/"..path..";"
				end
			end
		end
	end
	
	local version = self.json.id
	return filePaths..info.corePath.."/versions/"..version.."/"..version..".jar"
end

function JsonManager:getMainClass()
	
	local mainClass = self.json.mainClass
	return {mainClass}
end


--game arguments
function JsonManager:getMinecraftArguments()
	
	return split(tostring(self.json.minecraftArguments)," ")
end

function JsonManager:getExtractList()

	list = {}
	for k, c in pairs(self.json.libraries) do
		if c.natives ~= nil then
			table.insert(list, info.corePath.."/libraries/"..c.downloads.classifiers["natives-windows"].path)
		end
	end
	
	return list
end

function JsonManager:getAssetIndex()

	return self.json.assets
end
