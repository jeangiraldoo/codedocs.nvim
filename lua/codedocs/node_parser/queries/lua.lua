return {
	identifier_pos = true,
	nodes = {function_declaration = "func"},
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
			{find = "return_statement", ""}
		}
	}
}
