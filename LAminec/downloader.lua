curl = require("luacurl")

local function get_result(url, c)
	local result = { }
	if c == nil then
		c = curl.new()
	end
	c:setopt(curl.OPT_URL, url)
	c:setopt(curl.OPT_WRITEDATA, result)
	c:setopt(curl.OPT_WRITEFUNCTION, function(tab, buffer)
		table.insert(tab, buffer)                      --tab������Ϊresult���ο�http://luacurl.luaforge.net/  
		return #buffer
	end)
	local ok = c:perform()
	return ok, table.concat(result)             --��table����һ��table��������ͬ  
end

function download(url, filename)
	ok, content = get_result(url)
	if ok then
		file = io.open("./"..filename, "w");
		if(file) then
			file:write(content);
			file:close();
		end
	else
		print ("Error" )
	end
end