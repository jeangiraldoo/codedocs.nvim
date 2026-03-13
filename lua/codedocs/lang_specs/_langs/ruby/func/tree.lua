return {
	parameters = {
		{
			type = "simple",
			query = [[
				(method
					(method_parameters
						(identifier) @item_name)) ]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[
				(return
					(_) @item_type
					(#set! parse_as_blank "true")) ]],
		},
	},
}
