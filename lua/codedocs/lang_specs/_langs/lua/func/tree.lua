return {
	parameters = {
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
	returns = {
		{
			type = "finder",
			collect_found_nodes = false,
			target_node_type = "return_statement",
		},
	},
}
