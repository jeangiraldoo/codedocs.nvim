return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("ruby", "codedocs_func_params"),
	}
end
