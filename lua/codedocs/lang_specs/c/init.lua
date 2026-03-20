local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(function_definition
			(function_declarator
				(parameter_list
					(parameter_declaration
						[
							(primitive_type)
							(struct_specifier
								(type_identifier))
						] @item_type
						[
							(identifier)
							(pointer_declarator
								(identifier))
						] @item_name))))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_definition
			(primitive_type) @item_type (#not-eq? @item_type "void"))
	]]
end

return {
	lang_name = "c",
	default_style = "Doxygen",
	identifier_pos = false,
	struct_identifiers = {
		function_definition = "func",
	},
	extractors = {
		func = Func_extractors,
	},
}
