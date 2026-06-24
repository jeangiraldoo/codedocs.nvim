local extractors = {}

function extractors.globals(target_data)
	local root_node = target_data.node:tree():root()

	local global_variables = target_data.extract_items {
		node = root_node,
		query = vim.treesitter.query.get("bash", "codedocs_global_vars"),
	}

	local variable_expansions_in_function = target_data.extract_items {
		query = vim.treesitter.query.get("bash", "codedocs_func_var_expansions"),
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
end

function extractors.parameters(target_data)
	return target_data.extract_items {
		query = vim.treesitter.query.get("bash", "codedocs_func_params"),
	}
end

function extractors.returns() return {} end

return {
	node_identifiers = {
		"function_definition",
	},
	extractors = extractors,
	opts = {},
}
