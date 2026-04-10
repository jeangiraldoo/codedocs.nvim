local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_declaration
			(function_value_parameters
				(parameter
					(simple_identifier) @item_name
					[
						(user_type)
						(function_type)
					] @item_type)))
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_declaration
			[
				(user_type)
				(function_type)
			] @item_type (#not-eq? @item_type "Unit"))
	]]
end

return {
	node_identifiers = {
		"function_declaration",
	},
	extractors = extractors,
}
