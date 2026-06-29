return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("java", "codedocs_class_instance_attributes"),
	}
end
