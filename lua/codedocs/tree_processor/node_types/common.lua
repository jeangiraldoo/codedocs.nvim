local function get_trimmed_table(tbl)
	local trimmed_tbl = {}
	for _, inner_tbl in pairs(tbl) do
		for _, val in ipairs(inner_tbl) do
			table.insert(trimmed_tbl, val)
		end
	end
	return trimmed_tbl
end

return {
	get_trimmed_table = get_trimmed_table
}
