local function get_tree(node_constructor)
	local params_section = {
		node_constructor({
			type = "simple",
			children = {

				[[
				[
					(method_declaration
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
					(function_definition
						(formal_parameters
							[
								(simple_parameter
									(primitive_type) @item_type
									(variable_name) @item_name
								)
								(simple_parameter
									(variable_name) @item_name
								)
							]
						)
					)
				]
			]],
			},
		}),
	}

	local return_type_section = {
		node_constructor({
			type = "finder",
			children = { "return_statement", "" },
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
