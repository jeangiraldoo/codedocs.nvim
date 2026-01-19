local GET_ALL_INSTANCE_ATTRS = {
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
}

local GET_CONSTRUCTOR_INSTANCE_ATTRS = {
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
}

local GET_COMPANION_OBJECT_ATTRS = {
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
}

local INCLUDE_INSTANCE_ATTRS = {
	type = "boolean",
	condition_opt_key = "include_instance_attrs",
	children = {
		{
			type = "boolean",
			condition_opt_key = "include_only_construct_instance_attrs",
			children = {
				GET_CONSTRUCTOR_INSTANCE_ATTRS,
				GET_ALL_INSTANCE_ATTRS,
			},
		},
	},
}

return {
	attrs = {
		{
			type = "boolean",
			condition_opt_key = "include_class_attrs",
			children = {
				{
					type = "accumulator",
					children = {
						GET_COMPANION_OBJECT_ATTRS,
						INCLUDE_INSTANCE_ATTRS,
					},
				},
				INCLUDE_INSTANCE_ATTRS,
			},
		},
	},
}
