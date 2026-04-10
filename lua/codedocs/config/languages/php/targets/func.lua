local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		parameters: (formal_parameters
			(simple_parameter
				type: [
				  (primitive_type) @item_type
				  (union_type) @item_type
				  (named_type) @item_type
				  (disjunctive_normal_form_type) @item_type
				  (intersection_type) @item_type
				]?
				name: (variable_name
					(name) @item_name)))
	]]
end

function extractors.returns(target_data)
	local items = target_data.lang_query_parser [[
		(function_definition
			return_type: [
				(primitive_type)
				(union_type)
				(named_type)
				(bottom_type)
				(intersection_type)
				(disjunctive_normal_form_type)
			] @item_type )
	]]
	if #items > 0 then return items end

	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

return {
	node_identifiers = {
		"function_definition",
		"method_declaration",
	},
	extractors = extractors,
	opts = {},
}
