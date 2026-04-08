local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(method
			(method_parameters
				(identifier) @item_name))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(return
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

---@alias CodedocsRubyStyleNames
---| "YARD"

---@alias CodedocsRubyStructNames
---| "func"
---| "comment"

---@class CodedocsRubyStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsRubyStyleNames, table<CodedocsRubyStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsRubyStyleNames

---@class CodedocsRubyConfig: CodedocsLanguageConfig
---@field styles CodedocsRubyStylesConfig

---@type CodedocsRubyConfig
return {
	lang_name = "ruby",
	styles = {
		default = "YARD",
		definitions = {
			YARD = require "codedocs.config.languages.ruby.YARD",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"method",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
