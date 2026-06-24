return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("javascript", "codedocs_func_returns"),
	}
end
