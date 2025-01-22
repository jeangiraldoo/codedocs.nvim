return {
	identifier_pos = true,
	nodes = {function_item = "func"},
	class = {""},
	func = {
		params = {
			[[
				(function_item
					(parameters
						(parameter
							(identifier) @item_name
							(type_identifier) @item_type
						)
					)
				)
			]]
		},
		return_type = {
			[[
				(function_item
					[
						(type_identifier) @item_type
						(primitive_type) @item_type
						(generic_type) @item_type
					]
				)
			]],
			{find = "return_expression", ""}
		}
	}
}
