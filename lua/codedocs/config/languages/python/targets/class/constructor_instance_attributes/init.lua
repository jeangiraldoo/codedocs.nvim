return function(target_data)
	local query = vim.treesitter.query.get("python", "codedocs_class_constructor")

	local constructor_node = target_data.extract_ts_nodes({ query = query })[1]
	local results = {}

	if constructor_node then
		results = target_data.extract_items {
			node = constructor_node,
			query = vim.treesitter.query.get("python", "codedocs_class_constructor_instance_attributes"),
		}
	end

	return results
end
