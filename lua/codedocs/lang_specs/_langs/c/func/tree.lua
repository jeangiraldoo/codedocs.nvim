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
									(struct_specifier
										(type_identifier) @item_type
									)
								]
								[
									(identifier) @item_name
									(pointer_declarator
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
	returns = {
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
