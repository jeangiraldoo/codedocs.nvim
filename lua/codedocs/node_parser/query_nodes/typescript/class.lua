local class_fields = [[
	(class_body
		(public_field_definition
			(property_identifier) @item_name
			(type_annotation) @item_type
		)
	)
]]

local function get_tree(node_constructor)
	local include_attr_section = node_constructor(
		{
			type = "boolean",
			children = {class_fields, ""}
		}
	)

	return {
		node_identifiers = {"class_declaration"},
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
