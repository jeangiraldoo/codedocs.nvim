local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	local raw_items = struct_data.lang_query_parser [[
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

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
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

---@class CodedocsGoStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsGoStyleNames, table<CodedocsGoStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsGoStyleNames

---@class CodedocsGoConfig: CodedocsLanguageConfig
---@field styles CodedocsGoStylesConfig

---@type CodedocsGoConfig
return {
	styles = {
		default = "Godoc",
		definitions = {
			Godoc = require "codedocs.config.languages.go.Godoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_declaration",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
