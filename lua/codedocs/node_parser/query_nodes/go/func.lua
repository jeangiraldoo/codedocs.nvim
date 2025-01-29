local function get_tree(node_constructor)
	local params_section ={
		node_constructor({
			type = "group",
			children = {
				[[
					(function_declaration
						(parameter_list
							(parameter_declaration
								(identifier) @item_name
								(type_identifier) @item_type
							)
						)
					)
				]]
			}
		})
	}

	local return_type_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
					(function_declaration
						(type_identifier) @item_type
					)
				]]
			}
		}),
		node_constructor({
			type = "finder",
			children = {
				"return_statement", ""
			}
		})
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
