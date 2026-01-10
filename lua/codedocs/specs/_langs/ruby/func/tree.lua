local PARAMS = {
	{
		type = "simple",
		children = {
			[[
				(method
					(method_parameters
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
			node_type = "return",
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
