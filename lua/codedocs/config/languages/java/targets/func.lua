local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(method_declaration
			(formal_parameters
				(formal_parameter
					type: [
						(integral_type)
						(floating_point_type)
						(generic_type)
						(boolean_type)
						(type_identifier)
						(array_type)
					] @item_type
					name: (identifier) @item_name)))
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(method_declaration
			type: [
				(integral_type)
				(floating_point_type)
				(generic_type)
				(boolean_type)
				(type_identifier)
				(array_type)
			 ] @item_type (#not-eq? @item_type "void"))
	]]
end

return {
	node_identifiers = {
		"method_declaration",
	},
	extractors = extractors,
	opts = {},
}
