local PARAMS = {
	{
		type = "simple",
		children = {
			[[
				(function_declaration
					(parameters
						(identifier) @item_name
					)
				)
			]],
		},
	},
}

local RETURN_TYPE = {
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
