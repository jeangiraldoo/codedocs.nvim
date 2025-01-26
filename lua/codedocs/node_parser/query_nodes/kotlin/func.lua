local function get_tree(node_constructor)
	local params_section = {
		node_constructor(
			{
				type = "simple",
				children = {
					[[
						(function_declaration
							(function_value_parameters
								(parameter
									(simple_identifier) @item_name
									(user_type) @item_type
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
						(function_declaration
							(user_type) @item_type
						)
					]]
				}
			}
		)
	}
	return {
		node_identifiers = {"function_declaration"},
		sections = {
			params = params_section,
			return_type = return_type_section
		}
	}
end

return {
	get_tree = get_tree
}
