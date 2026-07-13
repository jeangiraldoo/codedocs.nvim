return {
	treesitter = function(target_data)
		local root_node = target_data.node:tree():root()

		local global_variables = target_data.extract_items {
			node = root_node,
			query = target_data.load_query("global_vars"),
		}

		local variable_expansions_in_function = target_data.extract_items {
			query = target_data.load_query("func_var_expansions"),
		}

		local globals_referenced = vim.iter(global_variables)
			:filter(function(global_var)
				for _, variable_expansion in ipairs(variable_expansions_in_function) do
					if variable_expansion.name == global_var.name then return true end
				end

				return false
			end)
			:totable()

		return globals_referenced
	end,
}
