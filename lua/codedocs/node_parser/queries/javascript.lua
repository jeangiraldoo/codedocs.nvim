return {
	identifier_pos = true,
	nodes = {
		class_declaration = "class",
		method_definition = "func",
		function_declaration = "func"
	},
	class = {
		attrs = {
			[[
    			(class_body
      				[
        				(field_definition
          					(property_identifier) @attr-name
        				)
      				]
    			)
  			]]
		}
	},
	func = {
		params = {
			[[
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
				]
			]]
		},
		return_type = {
			{find = "return_statement", ""}
		}
	}
}
