local GET_METHODS = [[
	(class_body
		(method_definition
			(statement_block) @target
		)
	)
]]

local GET_CONSTRUCTOR = [[
	(class_body
		(method_definition
			(property_identifier) @name
			(#eq? @name "constructor")
		) @target
	)
]]

local GET_ATTRS_IN_METHODS = [[
	(assignment_expression
		(member_expression
			(property_identifier) @item_name
		)
	)
]]

local GET_CLASS_ATTRS = [[
	(class_body
		(public_field_definition
			"static"
			(property_identifier) @item_name
		)
	)
]]

local REGEX = {
	type = "regex",
	data = {
		pattern = "%f[%a]static%f[%A]",
		mode = false,
		query = [[(property_identifier) @item_name]],
	},
}

local GET_BODY_INSTANCE_ATTRS = {
	type = "chain",
	children = { [[(class_body) @target]], [[(public_field_definition) @target]], REGEX },
}

local METHOD_ATTR_FINDER = {
	type = "finder",
	data = {
		node_type = "assignment_expression",
		mode = true,
		def_val = "",
	},
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
	children = { GET_CONSTRUCTOR, METHOD_ATTR_FINDER, GET_ATTRS_IN_METHODS },
}

local GET_INSTANCE_ATTRS = {
	type = "boolean",
	children = { GET_ONLY_CONSTRUCTOR_ATTRS, GET_ALL_INSTANCE_ATTRS },
}

local INCLUDE_INSTANCE_ATTRS_OR_NOT = {
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
						GET_CLASS_ATTRS,
						INCLUDE_INSTANCE_ATTRS_OR_NOT,
					},
				},
				INCLUDE_INSTANCE_ATTRS_OR_NOT,
			},
		},
	},
}
