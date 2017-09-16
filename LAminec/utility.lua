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

local function num2char(num,k)                                   -- convert the unicode number into character  
    local char = string.char  
    local c,r = ''  
    for i = 1,k do  
        r,num = num%0x40, math.floor((num/0x40))  
        c=table.concat({char(r+0x80),c})  
    end  
    return c,num  
end  

function toUTF8(s)                    -- convert the json string unicode into character  
	local char = string.char  
	local n,c=tonumber(s)  
	if n<0x80 then                     --1 byte  
		return char(n)  
	elseif n<0x800 then                 --2 byte  
		c,n = num2char(n,1)  
		return table.concat({char(n+0xc0) , c})  
	elseif n<0x10000 then               --3 byte  
		c,n = num2char(n,2)  
		return table.concat({char(n+0xe0),c})  
	elseif n<0x200000 then              --4 byte  
		c,n = num2char(n,3)  
		return table.concat({char(n+0xf0) , c})  
	elseif n<0x4000000 then             --5 byte  
		c,n = num2char(n,4)  
		return table.concat({char(n+0xf8) , c})  
	else                                --6 byte  
		c,n = num2char(n,5)  
		return table.concat({char(n+0xfc) , c})  
	end  
end

function toUnicode(c,k)                                    -- convert character into unicode code(number)  
	local byte = string.byte  
	local n,tmp = 0  
	if 1 == k then  
		n = byte(c)  
	elseif 2 == k then  
		n = byte(c,1) - 0xc0  
		for i=2,k do  
			tmp =byte(c,i) - 0x80  
			n = n*0x40+tmp  
		end  
	elseif 3 == k then  
		n = byte(c,1) - 0xe0  
		for i=2,k do  
			tmp =byte(c,i) - 0x80  
			n = n*0x40+tmp  
		end  
	elseif 4 == k then  
		n = byte(c,1) - 0xf0  
		for i=2,k do  
			tmp =byte(c,i) - 0x80  
			n = n*0x40+tmp  
		end  
	elseif 5 == k then  
		n = byte(c,1) - 0xf8  
		for i=2,k do  
			tmp =byte(c,i) - 0x80  
			n = n*0x40+tmp  
		end  
	elseif 6 == k then  
		n = byte(c,1) - 0xfc  
		for i=2,k do  
			tmp =byte(c,i) - 0x80  
			n = n*0x40+tmp  
		end  
	end  
	return n  
end