local Func_extractors = {}

function Func_extractors.globals(struct_data)
	local root_node = struct_data.node:tree():root()

	local global_variables = (function()
		local query = vim.treesitter.query.parse(
			struct_data.lang_name,
			[[
				((variable_assignment
					(variable_name) @target) @variable_assignment
				(#not-has-parent? @variable_assignment declaration_command))
			]]
		)
		return vim.iter(query:iter_matches(root_node, 0)):map(function(_, match) return match[1][1] end):totable()
	end)()

	local variable_expansions_in_function = (function()
		local query = vim.treesitter.query.parse(struct_data.lang_name, "(expansion) @t")
		return vim.iter(query:iter_matches(struct_data.node, 0))
			:map(function(_, match)
				local match_node = match[1][1]

				local variable_reference = struct_data.generic_query_parser(
					match_node,
					struct_data.lang_name,
					[[
							((expansion
								(variable_name) @item_name))
						]]
				)[1]
				return variable_reference
			end)
			:totable()
	end)()

	local globals_referenced = {}
	for _, global_variable in ipairs(global_variables) do
		for _, variable_reference in ipairs(variable_expansions_in_function) do
			if variable_reference and variable_reference.name == vim.treesitter.get_node_text(global_variable, 0) then
				table.insert(globals_referenced, variable_reference)
			end
		end
	end
	return globals_referenced
end

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(command
			argument: (string
				(simple_expansion
					(variable_name) @item_name)))
	]]
end

function Func_extractors.returns() return {} end

return {
	lang_name = "bash",
	identifier_pos = true,
	supported_styles = {
		"Google",
	},
	styles = {
		default = "Google",
		definitions = {
			func = require "codedocs.lang_specs.bash.func",
			comment = require "codedocs.lang_specs.bash.comment",
		},
	},
	extraction = {
		struct_identifiers = {
			function_definition = "func",
		},
		extractors = {
			func = Func_extractors,
		},
	},
}
