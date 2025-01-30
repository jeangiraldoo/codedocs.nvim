local get_all_instance_attrs = [[
	(class_declaration
		[
			(class_body
				(property_declaration
					(variable_declaration
						(simple_identifier) @item_name
						(user_type) @item_type
					)
				)
			)
			(primary_constructor
				(class_parameter
					(binding_pattern_kind)
					(simple_identifier) @item_name
					(user_type) @item_type
				)
			)
		]
	)
]]

local get_constructor_instance_attrs = [[
	(class_declaration
		(primary_constructor
			(class_parameter
				(binding_pattern_kind)
				(simple_identifier) @item_name
				(user_type) @item_type
			)
		)
	)
]]

local get_companion_object_attrs = [[
	(companion_object
		(class_body
			(property_declaration
				(variable_declaration
					(simple_identifier) @item_name
					(user_type) @item_type
				)
			)
		)
	)

]]

local no_fields = ""

local function get_tree(node_constructor)
	local get_instance_attrs = node_constructor({
		type = "boolean",
		children = {get_constructor_instance_attrs, get_all_instance_attrs}
	})
	local include_instance_attrs = node_constructor({
		type = "boolean",
		children = {get_instance_attrs, no_fields}
	})
	local include_class_attrs = node_constructor({
		type = "accumulator",
		children = {get_companion_object_attrs, include_instance_attrs}
	})
	local include_attrs = node_constructor({
		type = "boolean",
		children = {include_class_attrs, include_instance_attrs}
	})

	return {
		node_identifiers = {"class_declaration"},
		sections = {
			attrs = {
				include_attrs
			}
		}
	}
end

return {
		get_tree = get_tree
}
