local get_methods = [[
	(class_definition
		body: (block
			(function_definition) @target
		)
	)
]]

local get_constructor = [[
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
	local find_method_attrs = node_constructor({
		type = "finder",
		data = {
			node_type = "attribute",
			mode = true,
			def_val = "",
		}
	})

	local get_all_attrs = node_constructor({
		type = "chain",
		children = { get_methods, find_method_attrs, get_method_attrs}
	})

	local get_only_constructor_attrs = node_constructor({
		type = "chain",
		children = { get_constructor, find_method_attrs, get_method_attrs }
	})

	local class_fields_node = node_constructor({
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
			]],
		},
	})

	local get_instance_attrs = node_constructor({
		type = "boolean",
		children = { get_only_constructor_attrs, get_all_attrs },
	})

	local include_instance_attrs_or_not = node_constructor({
		type = "boolean",
		children = { get_instance_attrs },
	})

	local include_the_class_fields = node_constructor({
		type = "accumulator",
		children = { class_fields_node, include_instance_attrs_or_not },
	})

	local include_class_fields_or_not = node_constructor({
		type = "boolean",
		children = { include_the_class_fields, include_instance_attrs_or_not },
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
