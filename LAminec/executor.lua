function process(executable, args)
	
	str = executable.." \""..table.concat(args, "\" \"").."\""
	os.execute(str)
end
