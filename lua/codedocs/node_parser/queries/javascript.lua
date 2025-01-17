return {
	identifier_pos = true,
	class = {
		attrs = [[
    		(class_body
      			[
        		(field_definition
          			(property_identifier) @attr-name
        		)
      			]
    		)
  		]]
	},
	func = {
		params = [[
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
	}
}
