return {
	sections = {
		params = {
			{
				type = "simple",
				children = {
					[[
						[
							(method_definition
								(formal_parameters
									(identifier) @item_name
								)
							)
							(function_declaration
								(formal_parameters
									(identifier) @item_name
								)
							)
						]
					]],
				},
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
	},
}
