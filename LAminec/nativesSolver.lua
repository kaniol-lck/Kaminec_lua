require("LAminec.info")
require("LAminec.utility")

function extractNatives(list)

	for k, c in ipairs(list) do 
		os.execute("7za ".."x \""..c.."\" \"-o"..info.gamePath.."/natives/\"".." -aos > 7zlog.txt")
	end
end