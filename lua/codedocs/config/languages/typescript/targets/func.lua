local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
				(formal_parameters
					(required_parameter
						(identifier) @item_name
						type: (type_annotation
							[
								(predefined_type)
								(array_type)
								(union_type)
								(generic_type)
								(tuple_type)
								(type_identifier)
								(literal_type)
								(object_type)
								(function_type)
							] @item_type )))
	]]
end

function extractors.returns(target_data)
	local items = target_data.lang_query_parser [[
		[
			(method_definition
				return_type: (type_annotation
					[
						(predefined_type)
						(array_type)
						(union_type)
						(generic_type)
						(tuple_type)
						(type_identifier)
						(literal_type)
						(object_type)
						(function_type)
					] @item_type (#not-eq? @item_type "void")))
			(function_declaration
				return_type: (type_annotation
					[
						(predefined_type)
						(array_type)
						(union_type)
						(generic_type)
						(tuple_type)
						(type_identifier)
						(literal_type)
						(object_type)
						(function_type)
					] @item_type (#not-eq? @item_type "void")))
		]
	]]

	if #items > 0 then return items end

	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

return {
	node_identifiers = {
		"method_definition",
		"function_declaration",
	},
	extractors = extractors,
	opts = {},
}
