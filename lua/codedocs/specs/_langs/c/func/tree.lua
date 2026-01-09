local function get_tree(node_constructor)
	local params_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
					(function_definition
						(function_declarator
							(parameter_list
								(parameter_declaration
									[
										(primitive_type) @item_type
										(struct_specifier
											(type_identifier) @item_type
										)
									]
									[
										(identifier) @item_name
										(pointer_declarator
											(identifier) @item_name
										)
									]
								)
							)
						)
					)
				]],
			},
		}),
	}

	local return_type_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
					(function_definition
						(primitive_type) @item_type
					)
				]],
			},
		}),
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
