return {
	params = {
		{
			type = "group",
			children = {
				{
					type = "simple",
					query = [[
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
	},
	return_type = {
		{
			type = "simple",
			query = [[
				(function_declaration
					(type_identifier) @item_type
				)
			]],
		},
		{
			type = "finder",
			collect_found_nodes = false,
			target_node_type = "return_statement",
		},
	},
}
