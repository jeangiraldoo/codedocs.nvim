local function get_tree(node_constructor)
	local params_section = {
		node_constructor(
			{
				type = "simple",
				children = {
					[[
						(function_definition
							(parameters
								[
									(typed_parameter
										(identifier) @item_name
										(#not-eq? @item_name "self")
										(type) @item_type
									)
									(identifier) @item_name
									(#not-eq? @item_name "self")
								]
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
						(function_definition
							(type) @item_type
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
