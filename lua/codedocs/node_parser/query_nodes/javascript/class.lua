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
			(propery_identifier) @name
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

local function get_tree(node_constructor)

	local class_fields_node = node_constructor(
		{
			type = "simple",
			children = {
				[[
					(class_declaration
						(class_body
							[
								(field_definition
									(property_identifier) @item_name
								)
							]
						)
					)
				]]
			}
		}
	)

	local get_all_attrs = node_constructor(
		{
			type = "double_recursion",
			children = {
				first_query = get_methods,
				second_query = get_attrs_in_methods,
				target = "assignment_expression"
			}
		}
	)

	local get_only_constructor_attrs = node_constructor(
		{
			type = "double_recursion",
			children = {
				first_query = get_constructor,
				second_query = get_attrs_in_methods,
				target = "assignment_expression"
			}
		}
	)

	local include_all_attrs = node_constructor(
		{
			type = "boolean",
			children = {get_all_attrs, get_only_constructor_attrs}
		}
	)

	local acc = node_constructor(
		{
			type = "accumulator",
			children = {class_fields_node, include_all_attrs}
		}
	)

	local no_attrs_node = node_constructor(
		{
			type = "simple",
			children = {""}
		}
	)

	local include_attr_section = node_constructor(
		{
			type = "boolean",
			children = {acc, no_attrs_node}
		}
	)

	local attrs_section = {
		include_attr_section
	}

	return {
		node_identifiers = {"class_declaration"},
		sections = {
			attrs = attrs_section
		}
	}
end

return {
	get_tree = get_tree
}
