return {
	params = {
		{
			type = "simple",
			query = [[
				(function_item
					(parameters
						(parameter
							(identifier) @item_name
							(type_identifier) @item_type
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
						(type_identifier) @item_type
						(primitive_type) @item_type
						(generic_type) @item_type
					]
				)
			]],
		},
	},
}
