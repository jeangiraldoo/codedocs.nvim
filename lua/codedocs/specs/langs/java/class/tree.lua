local get_class_fields = [[
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
]]

local get_instance_attrs = [[
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
]]
local no_attrs = ""

local function get_tree(node_constructor)
	local include_instance_attrs = node_constructor({
		type = "boolean",
		children = {get_instance_attrs, ""}
	})
	local include_class_fields = node_constructor({
		type = "accumulator",
		children = {get_class_fields, include_instance_attrs}
	})

	local include_attrs = node_constructor({
		type = "boolean",
		children = {include_class_fields, include_instance_attrs}
	})
	return {
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
