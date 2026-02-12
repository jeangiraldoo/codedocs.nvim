return {
	parameters = {
		{
			type = "simple",
			query = [[
				(function_definition
					(parameters
						[
							(typed_parameter
								(identifier) @item_name
								(#not-eq? @item_name "self")
								(type) @item_type
							)
							(identifier) @item_name
							(#not-eq? @item_name "self")
						]
					)
				)
			]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(function_definition
					(type) @item_type (#not-eq? @item_type "None")
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
