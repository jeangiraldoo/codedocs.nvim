return {
	identifier_pos = true,
	class = {
		attrs =	{
			[[
				(class_definition
					body: (block
						(expression_statement
			  				(assignment
								left: (_) @item_name
			  				)
						)
		  			)
				)
			]]
		}
	},
	func = {
		params = {
			[[
		  		(function_definition
					(parameters
			  			[
							(typed_parameter
				  				(identifier) @item_name
				  				(type) @item_type
							)
							(identifier) @item_name
			  			]
					)
		  		)
			]]
		},
		return_type = {
			[[
				(function_definition
					(type) @item_type
				)

			]],
			{"return_statement", ""}
		}
	}
}
