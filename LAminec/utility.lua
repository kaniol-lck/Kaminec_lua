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

function connect(list1, list2)
	local list3 = {}
	
	for i = 1, #list1 do
		table.insert(list3, list1[i])
	end
	
	for i = 1, #list2 do
		table.insert(list3, list2[i])
	end
	return list3
end

function contains(t, v)
	return t[v] ~= nil
end

function generateFileName(name)
	local list = split(name, ":")
	return string.gsub(list[1], "%.", "/").."/"..list[2].."/"..list[3].."/"..list[2].."-"..list[3]..".jar"
end
