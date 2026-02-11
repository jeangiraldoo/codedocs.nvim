return {
	parameters = {
		{
			type = "simple",
			query = [[
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
	return_type = {
		{
			type = "finder",
			collect_found_nodes = false,
			target_node_type = "return_statement",
		},
	},
}
