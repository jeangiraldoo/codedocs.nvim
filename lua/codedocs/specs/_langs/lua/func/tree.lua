return {
	params = {
		{
			type = "simple",
			query = [[
				(function_declaration
					(parameters
						(identifier) @item_name
					)
				)
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
