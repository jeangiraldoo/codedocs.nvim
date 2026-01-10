local PARAMS = {
	{
		type = "simple",
		children = {
			[[
				(method_declaration
					(formal_parameters
						(formal_parameter
							(_) @item_type
							(identifier) @item_name
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
				(method_declaration
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
