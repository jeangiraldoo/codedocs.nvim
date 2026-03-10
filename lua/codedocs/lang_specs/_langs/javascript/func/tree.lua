return {
	parameters = {
		{
			type = "simple",
			query = [[
				[
					(method_definition
						(formal_parameters
							(identifier) @item_name
						)
					)
					(function_declaration
						(formal_parameters
							(identifier) @item_name
						)
					)
					(arrow_function
						parameters: (formal_parameters
							(identifier) @item_name
						)
					)
				]
			]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(return_statement
					(_) @item_type (#set! parse_as_blank "true")
				)
			]],
		},
	},
}
