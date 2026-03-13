return {
	parameters = {
		{
			type = "simple",
			query = [[
				(function_definition
					(parameters
						[
							(typed_parameter
								(identifier) @item_name
								(#not-eq? @item_name "self")
								(type) @item_type)
							(identifier) @item_name (#not-eq? @item_name "self")
						])) ]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
					(function_definition
						return_type: (type
							(identifier) @item_type (#not-eq? @item_type "None"))) ]],
		},
		{
			type = "simple",
			query = [[
				(return_statement
					(_) @item_type
					(#set! parse_as_blank "true")) ]],
		},
	},
}
