-- @param structs Structure types to check for
-- @return string Structure name
-- @return vim.treesitter._tsnode
return function(struct_identifiers)
	assert(
		type(struct_identifiers) == "table",
		"struct_identifiers must be a table (got " .. type(struct_identifiers) .. ")"
	)

	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	if node_at_cursor == nil then return "comment", node_at_cursor end

	while node_at_cursor do
		local node_type = node_at_cursor:type()
		local struct_name = struct_identifiers[node_type]

		if struct_name then return struct_name, node_at_cursor end

		node_at_cursor = node_at_cursor:parent()
	end
	return "comment", node_at_cursor
end
