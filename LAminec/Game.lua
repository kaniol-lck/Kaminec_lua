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

	JVMArgs = {
		"-XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump",
		"-XX:+UseG1GC",
        "-XX:-UseAdaptiveSizePolicy",
        "-XX:-OmitStackTraceInFastThrow",
		string.format("-Djava.library.path=%s/natives", info.gamePath),
        "-Dfml.ignoreInvalidMinecraftCertificates=true",
        "-Dfml.ignorePatchDiscrepancies=true"}
	
	table.insert(JVMArgs, string.format("-Xmn%dm", info.minMem))
	table.insert(JVMArgs, string.format("-Xmx%dm", info.maxMem))
	table.insert(JVMArgs, "-cp")
	table.insert(JVMArgs, table.concat(self.jsonManager:getClassPaths(), ";"))
	
	return JVMArgs
end

function Game:getGameArgs()
	
	minecraftArguments = self.jsonManager:getMinecraftArguments()
	
	replace_list = {
		["${auth_player_name}"] = self.profile.playerName,
		["${version_name}"] = self.profile.lastVersionId,
		["${game_directory}"] = self.profile.gamePath,
		["${assets_root}"] = self.profile.corePath.. "/assets",
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
		os.execute(string.format([[start 7za x "%s" "-o%s/natives/" -aos > 7zlog.txt]], c, info.gamePath))
	end
end
