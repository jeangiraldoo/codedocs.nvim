local RETURN_TYPE = {
	{
		type = "simple",
		children = {
			[[
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
	{
		type = "finder",
		data = {
			node_type = "return_expression",
			mode = false,
			def_val = "",
		},
	},
}

local PARAMS = {
	{
		type = "simple",
		children = {
			[[
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
}

return {
	sections = {
		params = PARAMS,
		return_type = RETURN_TYPE,
	},
}
