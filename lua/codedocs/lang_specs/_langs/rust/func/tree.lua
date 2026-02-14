return {
	parameters = {
		{
			type = "simple",
			query = [[
				(function_item
					(parameters
						(parameter
							(identifier) @item_name
							[
								(type_identifier)
								(primitive_type)
							] @item_type
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
				(function_item
					[
						(primitive_type)
						(type_identifier)
					] @item_type (#not-eq? @item_type "()")
				)
			]],
		},
	},
}
