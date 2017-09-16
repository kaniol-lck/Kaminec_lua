require("lfs")

require("LAminec.gameJson")
require("LAminec.JVMKiller")
require("LAminec.nativesSolver")
require("LAminec.info")

local t = os.clock()

gameJson.fromFile(info.lastUsedVersion)

local JVMArgs = table.concat(JVMArgs()," ")

local after_cp = gameJson.after_cp()
local mainClass = gameJson.mainClass()
local gameArgs = gameJson.gameArgs()

extractNatives(gameJson.extractList())

local arg = [[start "" "]]..info.javaPath.."\" "..JVMArgs.." "..after_cp.." "..mainClass.." "..gameArgs

print(os.clock() - t)

os.execute(arg)