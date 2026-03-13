return {
	globals = {
		{
			type = "function",
			callback = function(node, children, lang_name, struct_style)
				local root_node = node:tree():root()

				local global_variables = (function()
					local query = vim.treesitter.query.parse(
						lang_name,
						[[
							((variable_assignment
								(variable_name) @target) @variable_assignment
							(#not-has-parent? @variable_assignment declaration_command))
						]]
					)
					return vim.iter(query:iter_matches(root_node, 0))
						:map(function(_, match) return match[1][1] end)
						:totable()
				end)()

				local variable_expansions_in_function = (function()
					local query = vim.treesitter.query.parse(lang_name, "(expansion) @t")
					return vim.iter(query:iter_matches(node, 0))
						:map(function(_, match)
							local match_node = match[1][1]

							local variable_reference = children[1]:process(match_node, lang_name, struct_style)[1]
							return variable_reference
						end)
						:totable()
				end)()

				local globals_referenced = {}
				for _, global_variable in ipairs(global_variables) do
					for _, variable_reference in ipairs(variable_expansions_in_function) do
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
					type = "simple",
					query = [[
						((expansion
							(variable_name) @item_name))
					]],
				},
			},
		},
	},
	parameters = {
		{
			type = "simple",
			query = [[
				(command
					argument: (string
						(simple_expansion
							(variable_name) @item_name)))
			]],
		},
	},
	returns = {
		{
			type = "simple",
			query = [[]],
		},
	},
}
