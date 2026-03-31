local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	local raw_items = struct_data.lang_query_parser [[
		(function_declaration
			(parameter_list
				(parameter_declaration
					(identifier) @item_name
					(type_identifier) @item_type)))
	]]

	local final_items = {}
	local standby = {}
	for _, item in ipairs(raw_items) do
		if item.name ~= "" and item.type == nil then
			table.insert(standby, item)
		elseif item.name ~= "" and item.type ~= "" then
			for _, standby_item in ipairs(standby) do
				standby_item.type = item.type
			end
			vim.list_extend(final_items, standby)
			standby = {}
			table.insert(final_items, item)
		end
	end

	return final_items
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_declaration
			(type_identifier) @item_type)
	]]
end

return {
	lang_name = "go",
	identifier_pos = true,
	supported_styles = {
		"Godoc",
	},
	styles = {
		default = "Godoc",
		definitions = {
			func = require "codedocs.lang_specs.go.func",
			comment = require "codedocs.lang_specs.go.comment",
		},
	},
	extraction = {
		struct_identifiers = {
			function_declaration = "func",
		},
		extractors = {
			func = Func_extractors,
		},
	},
}
