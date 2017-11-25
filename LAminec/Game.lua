require("lfs")
require("LAminec.class")

require("LAminec.info")
require("LAminec.profile")
require("LAminec.utility")
require("LAminec.executor")

Game = class()

function Game:ctor(profile)
	self.jsonManager = JsonManager.new(info.lastVersionId)
	self.profile = profile
end

function Game:start()
	
	self:extractNatives()
	startCode = self:getStartCode()
		
	process(info.javaPath, startCode)
end

function Game:getStartCode()
	
	return connect(self:getJVMArgs(), self:getGameArgs())
end

function Game:getJVMArgs()

	return connect({
		"-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump",
		"-XX:+UseG1GC",
        "-XX:-UseAdaptiveSizePolicy",
        "-XX:-OmitStackTraceInFastThrow",
		"-Xmn128m",
		"-Xmx1024m",
		"-Djava.library.path="..lfs.currentdir().."/.minecraft/natives",
        "-Dfml.ignoreInvalidMinecraftCertificates=true",
        "-Dfml.ignorePatchDiscrepancies=true",
		"-cp"}, {self.jsonManager:getClassPaths()})
end

function Game:getGameArgs()
	
	minecraftArguments = self.jsonManager:getMinecraftArguments()
	
	replace_list = {
		["${auth_player_name}"] = self.profile.playerName,
		["${version_name}"] = self.profile.lastVersionId,
		["${game_directory}"] = self.profile.gamePath,
		["${assets_root}"] = self.profile.corePath--[[.. "/assets"]],
		["${assets_index_name}"] = self.jsonManager:getAssetIndex(),
		["${user_type}"] = "Legacy",
		["${version_type}"] = "Kaminec Launcher",
		["${user_properties}"] = "{}",
	}
		
	for i = 1, #minecraftArguments do
		for k, c in pairs(replace_list) do
			minecraftArguments[i] = string.gsub(minecraftArguments[i], k, c)
		end
	end
	return connect(self.jsonManager:getMainClass(), minecraftArguments)
end

function Game:extractNatives()

	for k, c in ipairs(self.jsonManager:getExtractList()) do 
		os.execute("7za ".."x \""..c.."\" \"-o"..info.gamePath.."/natives/\"".." -aos > 7zlog.txt")
	end
end
