local extractors = {}

function extractors.globals(target_data)
	local root_node = target_data.node:tree():root()

	local global_variables = target_data.generic_query_parser(
		root_node,
		target_data.lang_name,
		[[
			((variable_name) @item_name
			(#has-parent? @item_name variable_assignment)
			(#not-has-ancestor? @item_name declaration_command))
		]]
	)

	local variable_expansions_in_function = target_data.generic_query_parser(
		target_data.node,
		target_data.lang_name,
		"(expansion (variable_name) @item_name)"
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
end

function extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(command
			argument: (string
				(simple_expansion
					(variable_name) @item_name)))
	]]
end

function extractors.returns() return {} end

return {
	node_identifiers = {
		"function_definition",
	},
	extractors = extractors,
	opts = {},
}
