local INCLUDE_INSTANCE_ATTRS_OR_NOT = {
	type = "boolean",
	condition = {
		section = "attrs",
		opt_key = "include_instance_attrs",
	},
	children = {
		{
			type = "boolean",
			condition = {
				section = "attrs",
				opt_key = "include_only_constructor_instance_attrs",
			},
			children = {
				{
					type = "chain",
					children = {
						{
							type = "simple",
							query = [[
								(function_definition
									name: (identifier) @func_name
									(#eq? @func_name "__init__")
								) @target
							]],
						},
						{
							type = "simple",
							query = [[
								(attribute
									(identifier) @item_name (#not-eq? @item_name "self")
								)
							]],
						},
					},
				},
				{
					type = "simple",
					query = [[
						(assignment
							left: (attribute
								object: (identifier) @obj
								attribute: (identifier) @item_name
							)
							(#eq? @obj "self")
							(#has-ancestor? @item_name function_definition)
						)
					]],
				},
			},
		},
	},
}

return {
	attrs = {
		{
			type = "boolean",
			condition = {
				section = "attrs",
				opt_key = "include_class_attrs",
			},
			children = {
				{
					type = "accumulator",
					children = {
						{
							type = "simple",
							query = [[
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
						},
						INCLUDE_INSTANCE_ATTRS_OR_NOT,
					},
				},
				INCLUDE_INSTANCE_ATTRS_OR_NOT,
			},
		},
	},
}
