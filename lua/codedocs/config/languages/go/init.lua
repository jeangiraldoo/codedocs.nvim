local Func_extractors = {}

function Func_extractors.parameters(target_data)
	local raw_items = target_data.lang_query_parser [[
		(function_declaration
			(parameter_list
				(parameter_declaration
					(identifier) @item_name
					type: [
						(slice_type)
						(array_type)
						(map_type)
						(function_type)
						(channel_type)
						(pointer_type)
						(struct_type)
						(type_identifier)
					] @item_type)))
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

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_declaration
			result: [
				(slice_type)
				(array_type)
				(map_type)
				(function_type)
				(channel_type)
				(pointer_type)
				(struct_type)
				(type_identifier)
			] @item_type)
	]]
end

---@alias CodedocsGoStyleNames
---| "Godoc"

---@alias CodedocsGoStructNames
---| "func"
---| "comment"

---@class CodedocsGoConfig: CodedocsLanguageConfig
---@field default_style CodedocsGoStyleNames
---@field styles table<CodedocsGoStyleNames, table<CodedocsGoStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsGoConfig
return {
	default_style = "Godoc",
	styles = {
		Godoc = require "codedocs.config.languages.go.Godoc",
	},
	targets = {
		func = {
			node_identifiers = {
				"function_declaration",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
