local extractors = {}

function extractors.parameters(target_data)
	local t = vim.treesitter.query.get("lua", "codedocs-func-params")
	return target_data.extract_items {
		query = t,
	}
end

function extractors.returns(target_data)
	local t = vim.treesitter.query.get("lua", "codedocs-func-returns")
	return target_data.extract_items {
		query = t,
	}
end

return {
	node_identifiers = {
		"function_definition",
		"function_declaration",
	},
	extractors = extractors,
	opts = {},
}
