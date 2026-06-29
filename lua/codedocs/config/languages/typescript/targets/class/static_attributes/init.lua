return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("typescript", "codedocs_class_static_attributes"),
	}
end
