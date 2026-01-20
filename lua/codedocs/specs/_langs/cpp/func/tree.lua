return {
	params = {
		{
			type = "simple",
			query = [[
				(function_definition
					(function_declarator
						(parameter_list
							(parameter_declaration
								[
									(primitive_type) @item_type
									(qualified_identifier
										(type_identifier) @item_type
									)
									(struct_specifier
										(type_identifier) @item_type
									)
								]
								[
									(identifier) @item_name
									(pointer_declarator
										(identifier) @item_name
									)
									(reference_declarator
										(identifier) @item_name
									)
								]
							)
						)
					)
				)
			]],
		},
	},
	return_type = {
		{
			type = "simple",
			query = [[
				(function_definition
					(primitive_type) @item_type
				)
			]],
		},
		{
			type = "finder",
			collect_found_nodes = false,
			target_node_type = "return_statement",
		},
	},
}
