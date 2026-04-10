local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		[
				parameters: (parameters
					name: (identifier) @item_name)
		]
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(return_statement
			(expression_list) @item_type
			(#set! parse_as_blank "true")) @return_statement (#has-ancestor? @return_statement function_declaration)
	]]
end

return {
	node_identifiers = {
		"function_definition",
		"function_declaration",
	},
	extractors = extractors,
	opts = {},
}
