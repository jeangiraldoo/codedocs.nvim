local function get_supported_node_data(structs)
	vim.treesitter.get_parser(0):parse()
	local node_at_cursor = vim.treesitter.get_node()

	if node_at_cursor == nil then return "comment", node_at_cursor end

	while node_at_cursor do
		for struct_name, value in pairs(structs) do
			if struct_name ~= "comment" then
				local node_identifiers = value["node_identifiers"]
				for _, id in pairs(node_identifiers) do
					if node_at_cursor:type() == id then return struct_name, node_at_cursor end
				end
			end
		end
		node_at_cursor = node_at_cursor:parent()
	end
	return "comment", node_at_cursor
end

return get_supported_node_data
