local extractors = {}

function extractors.parameters(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("ruby", "codedocs_func_params"),
	}
end

function extractors.returns(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("ruby", "codedocs_func_returns"),
	}
end

return {
	node_identifiers = {
		"method",
	},
	extractors = extractors,
	opts = {},
}
