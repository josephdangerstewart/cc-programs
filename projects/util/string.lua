local function startsWith(s, frag)
	return string.sub(s,1,string.len(frag)) == frag
end

return {
	startsWith = startsWith,
}
