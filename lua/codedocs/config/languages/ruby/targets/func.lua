local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(method
			(method_parameters
				(identifier) @item_name))
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(return
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

return {
	node_identifiers = {
		"method",
	},
	extractors = extractors,
	opts = {},
}
