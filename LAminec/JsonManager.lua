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
	
	local classPaths = {}
	for k, c in pairs(self.json.libraries) do
		if not contains(c, "natives") then 
			if contains(c, "downloads") and contains(c.downloads, "artifact") then
				table.insert(classPaths, info.corePath.."/libraries/"..c.downloads.artifact.path)
			else
				table.insert(classPaths, info.corePath.."/libraries/"..generateFileName(c.name))
			end
		end
	end
	--genFileName
	
	if contains(self.json, "inheritsFrom") then
		local inheritedJson = JsonManager.new(self.json.inheritsFrom)
		inheritedClassPaths = inheritedJson:getClassPaths()
		for i = 1, #inheritedClassPaths do
			table.insert(classPaths, inheritedClassPaths[i])
		end
	else
		local version = self.json.id
		table.insert(classPaths, info.corePath.."/versions/"..version.."/"..version..".jar")
	end
	
	return classPaths
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
		if contains(c, "natives") and contains(c.natives, "windows") then
			key = string.gsub(c.natives.windows, "${arch}", 32)
			table.insert(list, info.corePath.."/libraries/"..c.downloads.classifiers[key].path)
		end
	end
	
	if contains(self.json, "inheritsFrom") then
		local inheritedJson = JsonManager.new(self.json.inheritsFrom)
		connect(list, inheritedJson:getExtractList())
	end
	
	return list
end

function JsonManager:getAssetIndex()

	if contains(self.json, "inheritsFrom") then
		local inheritedJson = JsonManager.new(self.json.inheritsFrom)
		return inheritedJson:getAssetIndex()
	else
		return self.json.assets
	end
end
