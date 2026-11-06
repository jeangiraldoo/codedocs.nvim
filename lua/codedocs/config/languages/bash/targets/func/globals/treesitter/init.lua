return {
	handler = function(detection, extractor_name, provider)
		local root_node = detection.node:tree():root()

		local global_variables =
			provider.extract_items(root_node, provider.load_query(detection, extractor_name, "global_vars"))

		local variable_expansions_in_function = provider.extract_items(
			detection.node,
			provider.load_query(detection, extractor_name, "func_var_expansions")
		)

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
