local function get_tree(node_constructor)
	local params_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
						[
							(method_definition
								(formal_parameters
									(required_parameter
										(identifier) @item_name
										(type_annotation) @item_type
									)
								)
							)
							(function_declaration
								(formal_parameters
									(required_parameter
										(identifier) @item_name
										(type_annotation) @item_type
									)
								)
							)
						]
					]],
			},
		}),
	}

	local return_type_section = {
		node_constructor({
			type = "simple",
			children = {
				[[
						[
							(method_definition
								(type_annotation
									[
										(predefined_type) @item_type
										(array_type) @item_type
									]
								)
							)
							(function_declaration
								(type_annotation
									[
										(predefined_type) @item_type
										(array_type) @item_type
									]
								)
							)
						]
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
