return {
	params = {
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
	return_type = {
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
