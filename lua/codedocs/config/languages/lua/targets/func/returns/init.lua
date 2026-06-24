return function(target_data)
	local t = vim.treesitter.query.get("lua", "codedocs-func-returns")
	return target_data.extract_items {
		query = t,
	}
end
