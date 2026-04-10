local extractors = {}

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			(function_declarator
				(parameter_list
					(parameter_declaration
						type: [
							(sized_type_specifier)
							(primitive_type)
							(struct_specifier
								(type_identifier))
							(type_identifier)
						] @item_type
						[
							(identifier)
							(pointer_declarator
								(identifier))
						] @item_name))))
	]]
end

function extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			type: [
				(sized_type_specifier)
				(primitive_type)
				(type_identifier)
			] @item_type (#not-eq? @item_type "void"))
	]]
end

return {
	node_identifiers = {
		"function_definition",
	},
	extractors = extractors,
	opts = {},
}
