return {
	parameters = {
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
					(primitive_type) @item_type (#not-eq? @item_type "void")
				)
			]],
		},
	},
}
