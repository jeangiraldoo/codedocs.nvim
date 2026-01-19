return {
	params = {
		{
			type = "simple",
			query = [[
				[
					(method_definition
						(formal_parameters
							(required_parameter
								(identifier) @item_name
								(type_annotation) @item_type
							)
						)
					)
					(function_declaration
						(formal_parameters
							(required_parameter
								(identifier) @item_name
								(type_annotation) @item_type
							)
						)
					)
				]
			]],
		},
	},
	return_type = {
		{
			type = "simple",
			query = [[
				[
					(method_definition
						(type_annotation
							[
								(predefined_type) @item_type
								(array_type) @item_type
							]
						)
					)
					(function_declaration
						(type_annotation
							[
								(predefined_type) @item_type
								(array_type) @item_type
							]
						)
					)
				]
			]],
		},
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
