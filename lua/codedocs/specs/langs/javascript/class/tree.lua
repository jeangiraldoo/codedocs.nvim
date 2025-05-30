local get_methods = [[
	(class_body
		(method_definition
			(statement_block) @target
		)
	)
]]

local get_constructor = [[
	(class_body
		(method_definition
			(property_identifier) @name
			(#eq? @name "constructor")
		) @target
	)
]]

local get_attrs_in_methods = [[
	(assignment_expression
		(member_expression
			(property_identifier) @item_name
		)
	)
]]

local get_class_attrs = [[
	(class_body
		(field_definition
			"static"
			(property_identifier) @item_name
		)
	)
]]

local function get_tree(node_constructor)
	local regex = node_constructor({
		type = "regex",
		data = {
			pattern = "%f[%a]static%f[%A]",
			mode = false,
			query = [[(property_identifier) @item_name]],
		},
	})

	local get_body_instance_attrs = node_constructor({
		type = "chain",
		children = { [[(class_body) @target]], [[(field_definition) @target]], regex },
	})

	local method_attr_finder = node_constructor({
		type = "finder",
		data = {
			node_type = "assignment_expression",
			mode = true,
			def_val = "",
		},
	})

	local get_all_method_attrs = node_constructor({
		type = "chain",
		children = { get_methods, method_attr_finder, get_attrs_in_methods },
	})

	local get_all_instance_attrs = node_constructor({
		type = "accumulator",
		children = { get_body_instance_attrs, get_all_method_attrs },
	})

	local get_only_constructor_attrs = node_constructor({
		type = "chain",
		children = { get_constructor, method_attr_finder, get_attrs_in_methods },
	})

	local get_instance_attrs = node_constructor({
		type = "boolean",
		children = { get_only_constructor_attrs, get_all_instance_attrs },
	})

	local include_instance_attrs_or_not = node_constructor({
		type = "boolean",
		children = { get_instance_attrs },
	})

	local include_class_fields = node_constructor({
		type = "accumulator",
		children = { get_class_attrs, include_instance_attrs_or_not },
	})

	local include_class_fields_or_not = node_constructor({
		type = "boolean",
		children = { include_class_fields, include_instance_attrs_or_not },
	})

	return {
		sections = {
			attrs = {
				include_class_fields_or_not,
			},
		},
	}
end

return {
	get_tree = get_tree,
}
