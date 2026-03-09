local GET_BODY_INSTANCE_ATTRS = {
	type = "chain",
	children = {
		{
			type = "simple",
			query = [[(class_body) @target]],
		},
		{
			type = "simple",
			query = [[(public_field_definition) @target]],
		},
		{
			type = "simple",
			query = [[
				(property_identifier) @item_name
				(#not-match? @item_name "static")
			]],
		},
	},
}

local METHOD_ATTR_FINDER = {
	type = "finder",
	collect_found_nodes = true,
	target_node_type = "assignment_expression",
}

local GET_ALL_METHOD_ATTRS = {
	type = "chain",
	children = {
		{
			type = "simple",
			query = [[
				(class_body
					(method_definition
						(statement_block) @target
					)
				)
			]],
		},
		METHOD_ATTR_FINDER,
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
}

local GET_ALL_INSTANCE_ATTRS = {
	type = "accumulator",
	children = {
		GET_BODY_INSTANCE_ATTRS,
		GET_ALL_METHOD_ATTRS,
	},
}

local GET_ONLY_CONSTRUCTOR_ATTRS = {
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
		METHOD_ATTR_FINDER,
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
}

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
				GET_ONLY_CONSTRUCTOR_ATTRS,
				GET_ALL_INSTANCE_ATTRS,
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
