local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		[
			(method_definition
				(formal_parameters
					(identifier) @item_name
				)
			)
			(function_declaration
				(formal_parameters
					(identifier) @item_name
				)
			)
			(arrow_function
				parameters: (formal_parameters
					(identifier) @item_name))
		]
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

return {
	node_identifiers = {
		"method_definition",
		"function_declaration",
		"arrow_function",
	},
	extractors = extractors,
	opts = {},
}
