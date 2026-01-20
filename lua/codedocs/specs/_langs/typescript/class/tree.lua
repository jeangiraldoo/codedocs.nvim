local GET_METHODS = {
	type = "simple",
	query = [[
		(class_body
			(method_definition
				(statement_block) @target
			)
		)
	]],
}

local GET_ATTRS_IN_METHODS = {
	type = "simple",
	query = [[
		(assignment_expression
			(member_expression
				(property_identifier) @item_name
			)
		)
	]],
}

local GET_CLASS_ATTRS = {
	type = "simple",
	query = [[
		(class_body
			(public_field_definition
				"static"
				(property_identifier) @item_name
			)
		)
	]],
}

local REGEX = {
	type = "regex",
	data = {
		pattern = "%f[%a]static%f[%A]",
		mode = false,
	},
	children = {
		{
			type = "simple",
			query = [[(property_identifier) @item_name]],
		},
	},
}

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
		REGEX,
	},
}

local METHOD_ATTR_FINDER = {
	type = "finder",
	collect_found_nodes = true,
	target_node_type = "assignment_expression",
}

local GET_ALL_METHOD_ATTRS = {
	type = "chain",
	children = { GET_METHODS, METHOD_ATTR_FINDER, GET_ATTRS_IN_METHODS },
}

local GET_ALL_INSTANCE_ATTRS = {
	type = "accumulator",
	children = { GET_BODY_INSTANCE_ATTRS, GET_ALL_METHOD_ATTRS },
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
		GET_ATTRS_IN_METHODS,
	},
}

local INCLUDE_INSTANCE_ATTRS_OR_NOT = {
	type = "boolean",
	condition_opt_key = "include_instance_attrs",
	children = {
		{
			type = "boolean",
			condition_opt_key = "include_only_construct_instance_attrs",
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
			condition_opt_key = "include_class_attrs",
			children = {
				{
					type = "accumulator",
					children = {
						GET_CLASS_ATTRS,
						INCLUDE_INSTANCE_ATTRS_OR_NOT,
					},
				},
				INCLUDE_INSTANCE_ATTRS_OR_NOT,
			},
		},
	},
}
