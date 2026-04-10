local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_item
			parameters: (parameters
				(parameter
					(identifier) @item_name
					type: [
						(type_identifier)
						(primitive_type)
						(array_type)
						(reference_type)
						(tuple_type)
						(generic_type)
						(function_type)
					] @item_type)))
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_item
			return_type: [
				(primitive_type)
				(type_identifier)
				(array_type)
				(reference_type)
				(tuple_type)
				(generic_type)
				(function_type)
			] @item_type (#not-eq? @item_type "()"))
	]]
end

return {
	node_identifiers = {
		"function_item",
	},
	extractors = extractors,
	opts = {},
}
