require("lfs")
require("json")

local infoFile, err = io.open(lfs.currentdir().."/info.json", "r")

if infoFile == nil then print(err) end
local content = infoFile:read("*a")
infoFile:close()

info = json.decode(content)