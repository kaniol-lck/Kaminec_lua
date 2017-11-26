function process(executable, args)
	
	str = "start \"\" ".."\""..executable.."\" \""..table.concat(args, "\" \"").."\""
	os.execute(str)
end
