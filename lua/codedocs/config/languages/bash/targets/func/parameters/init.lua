return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("bash", "codedocs_func_params"),
	}
end
