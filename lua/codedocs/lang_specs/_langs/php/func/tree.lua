return {
	parameters = {
		{
			type = "simple",
			query = [[
				[
					(method_declaration
						(formal_parameters
							(simple_parameter
								(primitive_type)? @item_type
								(variable_name
									(name) @item_name
								)
							)
						)
					)
					(function_definition
						(formal_parameters
							(simple_parameter
								(primitive_type)? @item_type
								(variable_name
									(name) @item_name
								)
							)
						)
					)
				]
			]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(return_statement
					(_) @item_type (#set! parse_as_blank "true")
				)
			]],
		},
	},
}
