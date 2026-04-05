local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		[
			(function_declaration
				parameters: (parameters
					name: (identifier) @item_name))
			(function_definition
				parameters: (parameters
					name: (identifier) @item_name))
		]
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(return_statement
			(expression_list) @item_type
			(#set! parse_as_blank "true")) @return_statement (#has-ancestor? @return_statement function_declaration)
	]]
end

---@alias CodedocsLuaStyleNames
---| "EmmyLua"
---| "LDoc"

---@alias CodedocsLuaStructNames
---| "func"
---| "comment"

---@class CodedocsLuaStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsLuaStyleNames, table<CodedocsLuaStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsLuaStyleNames

---@class CodedocsLuaConfig: CodedocsLanguageConfig
---@field styles CodedocsLuaStylesConfig

---@type CodedocsLuaConfig
return {
	lang_name = "lua",
	identifier_pos = true,
	styles = {
		default = "EmmyLua",
		definitions = {
			EmmyLua = require "codedocs.config.languages.lua.EmmyLua",
			LDoc = require "codedocs.config.languages.lua.LDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_definition",
				"function_declaration",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
