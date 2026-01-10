local PARAMS = {
	{
		type = "simple",
		children = {
			[[
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
}

local RETURN_TYPE = {
	{
		type = "simple",
		children = {
			[[
				(function_definition
					(primitive_type) @item_type
				)
			]],
		},
	},
	{
		type = "finder",
		data = {
			node_type = "return_statement",
			mode = false,
			def_val = "",
		},
	},
}

return {
	sections = {
		params = PARAMS,
		return_type = RETURN_TYPE,
	},
}
