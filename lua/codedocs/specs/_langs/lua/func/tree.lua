local function get_tree(node_constructor)
	local params_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
						(function_declaration
							(parameters
								(identifier) @item_name
							)
						)
					]],
			},
		}),
	}

	local return_type_section = {
		node_constructor({
			type = "finder",
			data = {
				node_type = "return_statement",
				mode = false,
				def_val = "",
			},
		}),
	}

	return {
		sections = {
			params = params_section,
			return_type = return_type_section,
		},
	}
end

return {
	get_tree = get_tree,
}
