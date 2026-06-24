local extractors = {}

function extractors.parameters(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("rust", "codedocs_func_params"),
	}
end

function extractors.returns(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("rust", "codedocs_func_returns"),
	}
end

return {
	node_identifiers = {
		"function_item",
	},
	extractors = extractors,
	opts = {},
}
