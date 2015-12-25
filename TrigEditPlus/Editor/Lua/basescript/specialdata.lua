function TEPComment(str)
	local callerLine = debug.getinfo(2).currentline
	__internal__AddSpecialData(callerLine, 0x9b0a58d8, str)
end
