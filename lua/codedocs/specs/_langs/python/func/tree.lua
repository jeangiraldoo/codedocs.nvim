local PARAMS = {
	{
		type = "simple",
		children = {
			[[
				(function_definition
					(parameters
						[
							(typed_parameter
								(identifier) @item_name
								(#not-eq? @item_name "self")
								(type) @item_type
							)
							(identifier) @item_name
							(#not-eq? @item_name "self")
						]
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
				(function_definition
					(type) @item_type
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
