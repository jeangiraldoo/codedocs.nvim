return {
	identifier_pos = true,
	nodes = {class_definition = "class", function_definition = "func"},
	class = {
		attrs =	{
			{
				query_accumulator = {
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
					]],
					{
						boolean = {
							{
								double_query_with_recursion = {
									[[
										(class_definition
											body: (block
												(function_definition) @target
											)
										)
									]],
									[[
										(attribute
											(identifier) @item_name
											(#not-eq? @item_name "self")
										)
									]]
								}
							},
							{
								double_query_with_recursion = {
									[[
										(class_definition
											body: (block
												(function_definition
													name: (identifier) @name
													(#eq? @name "__init__")
												) @target
											)
										)
									]],
									[[
										(attribute
											(identifier) @item_name
											(#not-eq? @item_name "self")
										)
									]]

								},
							},

						}
					}
				}
			}
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
								(#not-eq? @item_name "self")
				  				(type) @item_type
							)
							(identifier) @item_name
							(#not-eq? @item_name "self")
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
			{find = {"return_statement", ""}}
		}
	}
}
