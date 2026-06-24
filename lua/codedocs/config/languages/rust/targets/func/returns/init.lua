return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("rust", "codedocs_func_returns"),
	}
end
