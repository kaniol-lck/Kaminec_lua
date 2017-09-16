require("lfs")

function split(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
		if not nFindLastIndex then  
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
			break  
		end  
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
		nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end

function printTable( tbl , level, filteDefault)
	local msg = ""
	filteDefault = filteDefault or true --Ä¬ÈÏ¹ýÂË¹Ø¼ü×Ö£¨DeleteMe, _class_type£©
	level = level or 1
	local indent_str = ""
	for i = 1, level do
		indent_str = indent_str.."  "
	end
	
	print(indent_str .. "{")
	for k,v in pairs(tbl) do
		if filteDefault then
			if k ~= "_class_type" and k ~= "DeleteMe" then
				local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
				print(item_str)
				if type(v) == "table" then
					printTable(v, level + 1)
				end
			end
		else
			local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
			print(item_str)
			if type(v) == "table" then
				printTable(v, level + 1)
			end
		end
	end
	print(indent_str .. "}")
end
