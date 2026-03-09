local INCLUDE_INSTANCE_ATTRS = {
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
					type = "simple",
					query = [[
						(class_declaration
							(primary_constructor
								(class_parameter
									(binding_pattern_kind)
									(simple_identifier) @item_name
									(user_type) @item_type
								)
							)
						)
					]],
				},
				{
					type = "simple",
					query = [[
						(class_declaration
							[
								(class_body
									(property_declaration
										(variable_declaration
											(simple_identifier) @item_name
											(user_type) @item_type
										)
									)
								)
								(primary_constructor
									(class_parameter
										(binding_pattern_kind)
										(simple_identifier) @item_name
										(user_type) @item_type
									)
								)
							]
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
								(companion_object
									(class_body
										(property_declaration
											(variable_declaration
												(simple_identifier) @item_name
												(user_type) @item_type
											)
										)
									)
								)
							]],
						},
						INCLUDE_INSTANCE_ATTRS,
					},
				},
				INCLUDE_INSTANCE_ATTRS,
			},
		},
	},
}
