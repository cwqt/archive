return {
	ConstantLength: (string, length) ->
		string = tostring(string)
		return utf8sub(string .. string.rep(" ", length-utf8len(string)), 1, length)

	StringPad: (str, len, char) ->
		return i .. string.rep(char, len-#str)
}
