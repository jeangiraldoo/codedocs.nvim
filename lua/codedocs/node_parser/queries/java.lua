return {
	identifier_pos = false,
	nodes = {class_declaration = "class", method_declaration = "func"},
	class = {
		attrs = {
			[[
    			(class_body
      				[
        				(field_declaration
          					(type_identifier) @attr-type
          					(variable_declarator
            					(identifier) @attr-name
          					)
        				)
      				]
    			)
  			]]
		}
	},
	func = {
		params = {
			[[
  				(method_declaration
    				(formal_parameters
      					(formal_parameter
        					(_) @item_type
        					(identifier) @item_name
      					)
    				)
  				)
			]]
		},
		return_type = {
			[[
				(method_declaration
					(type_identifier) @item_type
				)
			]],
			{find = "return_statement", ""}
		}
	}
}
