local GET_ALL_INSTANCE_ATTRS = [[
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
]]

local GET_CONSTRUCTOR_INSTANCE_ATTRS = [[
	(class_declaration
		(primary_constructor
			(class_parameter
				(binding_pattern_kind)
				(simple_identifier) @item_name
				(user_type) @item_type
			)
		)
	)
]]

local GET_COMPANION_OBJECT_ATTRS = [[
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

]]

local GET_INSTANCE_ATTRS = {
	type = "boolean",
	children = { GET_CONSTRUCTOR_INSTANCE_ATTRS, GET_ALL_INSTANCE_ATTRS },
}

local INCLUDE_INSTANCE_ATTRS = {
	type = "boolean",
	children = { GET_INSTANCE_ATTRS },
}

return {
	attrs = {
		{
			type = "boolean",
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
