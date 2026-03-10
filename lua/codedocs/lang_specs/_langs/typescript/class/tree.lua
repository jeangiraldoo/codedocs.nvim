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
								(class_body
									(method_definition
										(property_identifier) @name
										(#eq? @name "constructor")
									) @target
								)
							]],
						},
						{
							type = "simple",
							query = [[
								(assignment_expression
									(member_expression
										(property_identifier) @item_name
									)
								)
							]],
						},
					},
				},
				{
					type = "accumulator",
					children = {
						{
							type = "simple",
							query = [[
								(public_field_definition
									(property_identifier) @item_name
									(#not-match? @item_name "static")
								)
							]],
						},
						{
							type = "simple",
							query = [[
								(assignment_expression
									(member_expression
										object: (this)
										property: (property_identifier) @item_name (#has-ancestor? @item_name method_definition)
									)
								)
							]],
						},
					},
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
								(class_body
									(public_field_definition
										"static"
										(property_identifier) @item_name
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
