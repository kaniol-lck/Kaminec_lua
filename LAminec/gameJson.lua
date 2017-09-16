require("json")
require("lfs")

require("LAminec.utility")
require("LAminec.info")

gameJson = {}

function gameJson.fromFile(version)

	local jsonFilePath = info.corePath.."/versions/"..version.."/"..version..".json"
	local jsonFile, err = io.open(jsonFilePath, "r")
	
	if jsonFile == nil then
		print(err)
		return
	end
	
	local content = jsonFile:read("*a")
	jsonFile:close()
	
	gameJson.json = json.decode(content)
end



function gameJson.after_cp()
	local libraries = gameJson.json.libraries
	local after = "-cp"
	
	local filePaths = ""
	for k, c in pairs(libraries) do
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
	
	local version = gameJson.json.id
	after = after.." \""..filePaths..info.corePath.."/versions/"..version.."/"..version..".jar\""
	return after
end

function gameJson.mainClass()
	
	local mainClass = gameJson.json.mainClass
	return mainClass
end


--game arguments
function gameJson.gameArgs()
	
	local minecraftArguments = gameJson.json.minecraftArguments
	
	minecraftArguments = string.gsub(minecraftArguments, "${auth_player_name}", info.playername)
	minecraftArguments = string.gsub(minecraftArguments, "${version_name}", gameJson.json.id)
	minecraftArguments = string.gsub(minecraftArguments, "${game_directory}", "\""..info.gamePath.."\"")
	minecraftArguments = string.gsub(minecraftArguments, "${assets_root}", "\""..info.corePath.."/assets\"")
	minecraftArguments = string.gsub(minecraftArguments, "${assets_index_name}", gameJson.json.assetIndex.id)
	minecraftArguments = string.gsub(minecraftArguments, "${user_type}", "Legacy")
	minecraftArguments = string.gsub(minecraftArguments, "${version_type}", "Kaminec_Launcher")
	
	return minecraftArguments
end

function gameJson.extractList()

	list = {}
	for k, c in pairs(gameJson.json.libraries) do
		if c.extract ~= nil then
			table.insert(list, info.corePath.."/libraries/"..c.downloads.classifiers["natives-windows"].path)
		end
	end
	
	return list
end