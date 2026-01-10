local PARAMS = {
	{
		type = "simple",
		children = {
			[[
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
}

local RETURN_TYPE = {
	{
		type = "simple",
		children = {
			[[
				(function_declaration
					(user_type) @item_type
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
