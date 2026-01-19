return {
	params = {
		{
			type = "simple",
			query = [[
				(method_declaration
					(formal_parameters
						(formal_parameter
							(_) @item_type
							(identifier) @item_name
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
				(method_declaration
					(type_identifier) @item_type
				)
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
