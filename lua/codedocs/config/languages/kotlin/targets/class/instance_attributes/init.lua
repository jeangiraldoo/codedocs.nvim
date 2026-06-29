return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("kotlin", "codedocs_class_all_instance_attributes"),
	}
end
