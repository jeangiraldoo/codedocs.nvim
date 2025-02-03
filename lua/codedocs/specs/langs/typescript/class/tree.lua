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
		(public_field_definition
			"static"
			(property_identifier) @item_name
		)
	)
]]

local function get_tree(node_constructor)
	local regex = node_constructor({
		type = "regex",
		children = {pattern = "%f[%a]static%f[%A]", mode = false, query = [[(property_identifier) @item_name]]}
	})

	local get_body_instance_attrs = node_constructor({
		type = "chain",
		children = {[[(class_body) @target]], [[(public_field_definition) @target]], regex}
	})

	local no_attrs_node = node_constructor({
		type = "simple",
		children = {""}
	})

	local get_all_method_attrs = node_constructor({
		type = "double_recursion",
		children = {
			first_query = get_methods,
			second_query = get_attrs_in_methods,
			target = "assignment_expression"
		}
	})

	local get_all_instance_attrs = node_constructor({
		type = "accumulator",
		children = {get_body_instance_attrs, get_all_method_attrs}
	})

	local get_only_constructor_attrs = node_constructor({
		type = "double_recursion",
		children = {
			first_query = get_constructor,
			second_query = get_attrs_in_methods,
			target = "assignment_expression"
		}
	})

	local get_instance_attrs = node_constructor({
		type = "boolean",
		children = {get_only_constructor_attrs, get_all_instance_attrs}
	})

	local include_instance_attrs_or_not = node_constructor(
		{
			type = "boolean",
			children = {get_instance_attrs, no_attrs_node}
		}
	)

	local include_class_fields = node_constructor({
		type = "accumulator",
		children = {get_class_attrs, include_instance_attrs_or_not}
	})

	local include_class_fields_or_not = node_constructor({
		type = "boolean",
		children = {include_class_fields, include_instance_attrs_or_not}
	})

	return {
		sections = {
			attrs = {
				include_class_fields_or_not
			}
		}
	}
end

return {
	get_tree = get_tree
}
