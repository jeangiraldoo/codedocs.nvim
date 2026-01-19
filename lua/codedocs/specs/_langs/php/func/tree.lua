return {
	params = {
		{
			type = "simple",
			query = [[
				[
					(method_declaration
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
					(function_definition
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
				]
			]],
		},
	},
	return_type = {
		{
			type = "finder",
			data = {
				node_type = "return_statement",
				mode = false,
				def_val = "",
			},
		},
	},
}
