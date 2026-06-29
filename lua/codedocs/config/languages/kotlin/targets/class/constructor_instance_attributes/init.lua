return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("kotlin", "codedocs_class_constructor_instance_attrs"),
	}
end
