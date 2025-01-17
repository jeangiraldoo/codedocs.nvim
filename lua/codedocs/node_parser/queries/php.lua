return {
	identifier_pos = false,
	class = {
		attrs = ""
	},
	func = {
		params = [[
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
	}
}
