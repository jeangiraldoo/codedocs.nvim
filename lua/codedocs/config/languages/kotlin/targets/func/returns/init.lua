return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("kotlin", "codedocs_func_returns"),
	}
end
