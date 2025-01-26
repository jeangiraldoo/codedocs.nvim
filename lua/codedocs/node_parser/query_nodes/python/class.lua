local get_methods = [[
	(class_definition
		body: (block
			(function_definition) @target
		)
	)
]]

local get_constructor =	[[
	(class_definition
		body: (block
			(function_definition
				name: (identifier) @name
				(#eq? @name "__init__")
			) @target
		)
	)
]]

local get_method_attrs = [[
	(attribute
		(identifier) @item_name
		(#not-eq? @item_name "self")
	)
]]


local function get_tree(node_constructor)
	local class_fields_node = node_constructor(
		{
			type = "simple",
			children = {
				[[
					(class_definition
						body: (block
							(expression_statement
								(assignment
									left: (_) @item_name
								)
							)
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
				second_query = get_method_attrs,
				target = "attribute"
			}
		}
	)

	local get_only_constructor_attrs = node_constructor(
		{
			type = "double_recursion",
			children = {
				first_query = get_constructor,
				second_query = get_method_attrs,
				target = "attribute"
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

	return {
		node_identifiers = {
			"class_definition"
		},
		sections = {
			attrs = {
				include_attr_section
			}
		}
	}
end

return {
	get_tree = get_tree
}
