local function get_tree(node_constructor)
	local params_section ={
		node_constructor(
			{
				type = "simple",
				children = {
					[[
						(method_declaration
							(formal_parameters
								(formal_parameter
									(_) @item_type
									(identifier) @item_name
								)
							)
						)
					]]

				}
			}
		)
	}

	local return_type_section = {
		node_constructor(
			{
				type = "simple",
				children = {
					[[
						(method_declaration
							(type_identifier) @item_type
						)
					]]
				}
			}
		),
		node_constructor(
			{
				type = "finder",
				children = {
					"return_statement", ""
				}
			}
		)
	}

	return {
		sections = {
			params = params_section,
			return_type = return_type_section
		}
	}
end

return {
	get_tree = get_tree
}
