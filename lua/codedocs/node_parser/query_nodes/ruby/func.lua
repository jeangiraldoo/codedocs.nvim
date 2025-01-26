local function get_tree(node_constructor)
	local params_section = {
		node_constructor(
			{
				type = "simple",
				children ={
					[[
			(method
				(method_parameters
					(identifier) @item_name
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
				type = "finder",
				children = {"return", ""}
			}
		)
	}

	return {
		node_identifiers = {"method"},
		sections = {
			params = params_section,
			return_type = return_type_section
		}
	}
end

return {
	get_tree = get_tree
}
