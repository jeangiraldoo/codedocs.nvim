return {
	identifier_pos = true,
	class = {
		attrs = {
			[[
    			(class_body
        			(public_field_definition
          				(property_identifier) @attr-name
          				(type_annotation) @attr-type
        			)
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
							(required_parameter
								(identifier) @item_name
								(type_annotation) @item_type
							)
						)
					)
					(function_declaration
						(formal_parameters
							(required_parameter
								(identifier) @item_name
								(type_annotation) @item_type
							)
						)
					)
				]
			]]
		},
		return_type = {
			[[
				[
					(method_definition
						(type_annotation
							[
								(predefined_type) @item_type
								(array_type) @item_type
							]
						)
					)
					(function_declaration
						(type_annotation
							[
								(predefined_type) @item_type
								(array_type) @item_type
							]
						)
					)
				]
			]]
		}
	}
}
