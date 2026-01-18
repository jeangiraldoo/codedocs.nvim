return {
	params = {
		{
			type = "group",
			children = {
				[[
				(function_declaration
					(parameter_list
						(parameter_declaration
							(identifier) @item_name
							(type_identifier) @item_type
						)
					)
				)
			]],
			},
		},
	},
	return_type = {
		{
			type = "simple",
			children = {
				[[
				(function_declaration
					(type_identifier) @item_type
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
	},
}
