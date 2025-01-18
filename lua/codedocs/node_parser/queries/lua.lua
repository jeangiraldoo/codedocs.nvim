return {
	identifier_pos = true,
	class = {
		attrs = {""}
	},
	func = {
		params = {
			[[
				(function_declaration
					(parameters
						(identifier) @item_name
					)
				)
			]]
		},
		return_type = {
			[[
				(function_declaration
					(block
						(return_statement) @item_type
					)
				)
			]]
		}
	}
}
