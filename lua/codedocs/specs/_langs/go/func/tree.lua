local PARAMS = {
	{
		type = "group",
		children = {
			[[
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
}

local RETURN_TYPE = {
	{
		type = "simple",
		children = {
			[[
				(function_declaration
					(type_identifier) @item_type
				)
			]],
		},
	},
	{
		type = "finder",
		data = {
			node_type = "return_statement",
			mode = false,
			def_val = "",
		},
	},
}

return {
	sections = {
		params = PARAMS,
		return_type = RETURN_TYPE,
	},
}
