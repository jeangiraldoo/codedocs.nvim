return {
	globals = {
		{
			type = "function",
			callback = function(node, children, lang_name, struct_style)
				local all_variable_assignment_TS_nodes = children[1]:process(node, lang_name, struct_style)

				local global_variables = {}
				for _, variable_assignment in ipairs(all_variable_assignment_TS_nodes) do
					local global_variable = children[2]:process(variable_assignment, lang_name, struct_style)

					if global_variable[1] then table.insert(global_variables, global_variable[1]) end
				end

				local variable_expansions_in_function = children[3]:process(node, lang_name, struct_style)

				local globals_referenced = {}
				for _, global_variable in ipairs(global_variables) do
					for _, variable_expansion in ipairs(variable_expansions_in_function) do
						local variable_reference = children[4]:process(variable_expansion, lang_name, struct_style)[1]
						if
							variable_reference
							and variable_reference.name == vim.treesitter.get_node_text(global_variable, 0)
						then
							table.insert(globals_referenced, variable_reference)
						end
					end
				end
				return globals_referenced
			end,
			children = {
				{
					type = "finder",
					find_from_root = true,
					collect_found_nodes = true,
					target_node_type = "variable_assignment",
				},
				{
					type = "simple",
					query = [[
						((variable_assignment
							(variable_name) @target
						) @variable_assignment
						(#not-has-parent? @variable_assignment declaration_command))
					]],
				},
				{
					type = "finder",
					find_from_root = false,
					collect_found_nodes = true,
					target_node_type = "expansion",
				},
				{
					type = "simple",
					query = [[
						((expansion
							(variable_name) @item_name
						))
					]],
				},
			},
		},
	},
	params = {
		{
			type = "chain",
			children = {
				{
					type = "finder",
					collect_found_nodes = true,
					target_node_type = "command",
				},
				{
					type = "simple",
					query = [[
					(command
						argument: (string
							(simple_expansion
								(variable_name) @item_name
							)
						)
					)
			]],
				},
			},
		},
	},
	return_type = {
		{
			type = "simple",
			query = [[]],
		},
	},
}
