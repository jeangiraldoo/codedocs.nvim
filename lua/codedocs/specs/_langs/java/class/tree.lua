local GET_CLASS_FIELDS = {
	type = "simple",
	query = [[
		(class_body
			(field_declaration
				(modifiers) @name
				(#match? @name "static")
				(type_identifier) @item_type
				(variable_declarator
					(identifier) @item_name
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
			type = "simple",
			query = [[
				(class_body
					(field_declaration
						(modifiers) @name
						(#not-match? @name "static")
						(type_identifier) @item_type
						(variable_declarator
							(identifier) @item_name
						)
					)
				)
			]],
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
						GET_CLASS_FIELDS,
						INCLUDE_INSTANCE_ATTRS,
					},
				},
				INCLUDE_INSTANCE_ATTRS,
			},
		},
	},
}
