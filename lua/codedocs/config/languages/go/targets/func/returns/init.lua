return function(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("go", "codedocs_func_returns"),
	}
end
