local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(method
			(method_parameters
				(identifier) @item_name))
	]]
end

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
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

---@class CodedocsRubyConfig: CodedocsLanguageConfig
---@field default_style CodedocsRubyStyleNames
---@field styles table<CodedocsRubyStyleNames, table<CodedocsRubyStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsRubyConfig
return {
	default_style = "YARD",
	styles = {
		YARD = require "codedocs.config.languages.ruby.YARD",
	},
	targets = {
		func = {
			node_identifiers = {
				"method",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
