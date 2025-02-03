local function get_tree(node_constructor)
	local params_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
					(function_item
						(parameters
							(parameter
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
					(function_item
						[
							(type_identifier) @item_type
							(primitive_type) @item_type
							(generic_type) @item_type
						]
					)
				]]
			}
		}),
		node_constructor({
			type = "finder",
			children = {"return_expression", ""}
		})
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
