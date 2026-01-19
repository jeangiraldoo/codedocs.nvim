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

local GET_INSTANCE_ATTRS = {
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
						GET_CLASS_FIELDS,
						INCLUDE_INSTANCE_ATTRS,
					},
				},
				INCLUDE_INSTANCE_ATTRS,
			},
		},
	},
}
