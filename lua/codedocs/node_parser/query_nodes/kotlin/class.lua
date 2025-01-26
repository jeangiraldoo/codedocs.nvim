local get_class_fields = [[
	(class_body
		(property_declaration
			(variable_declaration
				(simple_identifier) @item_name
				(user_type) @item_type
			)
		)
	)
]]

local no_fields = ""

local function get_tree(node_constructor)
	return {
		node_identifiers = {"class_declaration"},
		sections = {
			attrs = {
				node_constructor(
					{
						type = "boolean",
						children = {get_class_fields, no_fields}
					}
				)
			}
		}
	}
end

return {
		get_tree = get_tree
}
