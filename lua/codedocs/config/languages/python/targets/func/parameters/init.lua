return function(target_data)
	local params = target_data.extract_items {
		query = vim.treesitter.query.get("python", "codedocs_func_params"),
	}

	return params
end
