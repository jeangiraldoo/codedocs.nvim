local function get_tree(node_constructor)
	local params_section ={
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
										(qualified_identifier
											(type_identifier) @item_type
										)
										(struct_specifier
											(type_identifier) @item_type
										)
									]
									[
										(identifier) @item_name
										(pointer_declarator
											(identifier) @item_name
										)
										(reference_declarator
											(identifier) @item_name
										)
									]
								)
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
					(function_definition
						(primitive_type) @item_type
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
		node_identifiers = {"function_definition"},
		sections = {
			params = params_section,
			return_type = return_type_section
		}
	}
end

return {
	get_tree = get_tree
}
