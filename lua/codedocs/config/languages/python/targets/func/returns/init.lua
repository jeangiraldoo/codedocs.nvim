return function(target_data)
	local items = target_data.extract_items {
		query = vim.treesitter.query.get("python", "codedocs_func_returns"),
	}

	if #items > 0 then return items end

	return target_data.extract_items {
		query = vim.treesitter.query.get("python", "codedocs_func_return_statement"),
	}
end
