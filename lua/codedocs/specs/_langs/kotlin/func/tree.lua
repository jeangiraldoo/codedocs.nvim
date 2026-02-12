return {
	parameters = {
		{
			type = "simple",
			query = [[
				(function_declaration
					(function_value_parameters
						(parameter
							(simple_identifier) @item_name
							(user_type) @item_type
						)
					)
				)
			]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(function_declaration
					(user_type) @item_type (#not-eq? @item_type "Unit")
				)
			]],
		},
	},
}
