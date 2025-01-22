return {
	identifier_pos = false,
	nodes = {method_declaration = "func", function_definition = "func"},
	class = {
		attrs = {""}
	},
	func = {
		params = {
			[[
				[
					(method_declaration
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
					(function_definition
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
				]
			]]
		},
		return_type = {
			{find = "return_statement", ""}
		}
	}
}
