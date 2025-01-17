return {
	identifier_pos = false,
	class = {
		attrs = [[
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
	},
	func = {
		params = [[
  (method_declaration
    (formal_parameters
      (formal_parameter
        (_) @item_type              ; Capture the type second
        (identifier) @item_name      ; Capture the name first
      )
    )
  )
]],
		return_type = [[
			(method_declaration
				type: (_) @return
			)
		]]
	}


}
