return function(target_data)
	local q = vim.treesitter.query.get("javascript", "codedocs_class_constructor")

	local constructor_node = target_data.extract_ts_nodes({ query = q })[1]

	local results = target_data.extract_items {
		node = constructor_node,
		query = vim.treesitter.query.get("javascript", "codedocs_class_method_instance_attributes"),
	}
	return results
end
