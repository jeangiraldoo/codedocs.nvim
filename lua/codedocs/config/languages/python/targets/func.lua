local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(parameters
			[
				(typed_parameter
					(identifier) @item_name
					(#not-eq? @item_name "self")
					(type) @item_type)
				(identifier) @item_name (#not-eq? @item_name "self")
			])
	]]
end

function extractors.returns(target_data)
	local items = target_data.lang_query_parser [[
		(function_definition
			return_type: (type
				[
					(identifier)
					(generic_type (identifier))
					(binary_operator)
				] @item_type (#not-eq? @item_type "None")))
	]]

	if #items > 0 then return items end

	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

return {
	node_identifiers = {
		"function_definition",
	},
	extractors = extractors,
}
