local extractors = {}

function extractors.parameters(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("php", "codedocs_func_params"),
	}
end

function extractors.returns(target_data)
	local items = target_data.extract_items {
		query = vim.treesitter.query.get("php", "codedocs_func_returns"),
	}

	if #items > 0 then return items end

	return target_data.extract_items {
		query = vim.treesitter.query.get("php", "codedocs_func_return_statement"),
	}
end

return {
	node_identifiers = {
		"function_definition",
		"method_declaration",
	},
	extractors = extractors,
	opts = {},
}
