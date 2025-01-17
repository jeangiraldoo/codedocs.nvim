return {
	identifier_pos = true,
	class = {
		attrs = [[
			(class_body
				[
				(property_declaration
					(variable_declaration
						(simple_identifier) @attr-name
						(user_type) @attr-type
					)
				)
				]
			)
		]]
	},
	func = {
		params = [[
			(function_declaration
				(function_value_parameters
					(parameter
						(simple_identifier) @item_name
						(user_type) @item_type
					)
				)
			)
		]]
	}
}
