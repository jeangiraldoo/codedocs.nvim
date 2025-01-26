local get_class_fields = [[
	(class_body
		(field_declaration
			(type_identifier) @item_type
				(variable_declarator
					(identifier) @item_name
				)
		)
    )
]]

local no_attrs = ""

local function get_tree(node_constructor)
	print("CLASS")
	return {
		node_identifiers = {"class_declaration"},
		sections = {
			attrs = {
				node_constructor(
					{
						type = "boolean",
						children = {get_class_fields, no_attrs}
					}
				)
			}
		}
	}
end

return {
	get_tree = get_tree
}
