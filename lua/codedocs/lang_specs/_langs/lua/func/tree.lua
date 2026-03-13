return {
	parameters = {
		{
			type = "simple",
			query = [[
				[
					(function_declaration
						parameters: (parameters
							name: (identifier) @item_name))
					(function_definition
						parameters: (parameters
							name: (identifier) @item_name))
				] ]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(return_statement
					(expression_list) @item_type
					(#set! parse_as_blank "true")) @return_statement (#has-ancestor? @return_statement function_declaration) ]],
		},
	},
}
