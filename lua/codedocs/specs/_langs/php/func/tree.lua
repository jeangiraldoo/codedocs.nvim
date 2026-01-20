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
			collect_found_nodes = false,
			target_node_type = "return_statement",
		},
	},
}
