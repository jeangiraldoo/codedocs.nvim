local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_item
			parameters: (parameters
				(parameter
					(identifier) @item_name
					type: [
						(type_identifier)
						(primitive_type)
						(array_type)
						(reference_type)
						(tuple_type)
						(generic_type)
						(function_type)
					] @item_type)))
	]]
end

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_item
			return_type: [
				(primitive_type)
				(type_identifier)
				(array_type)
				(reference_type)
				(tuple_type)
				(generic_type)
				(function_type)
			] @item_type (#not-eq? @item_type "()"))
	]]
end

---@alias CodedocsRustStyleNames
---| "RustDoc"

---@alias CodedocsRustStructNames
---| "func"
---| "comment"

---@class CodedocsRustConfig: CodedocsLanguageConfig
---@field default_style CodedocsRustStyleNames
---@field styles table<CodedocsRustStyleNames, table<CodedocsRustStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsRustConfig
return {
	default_style = "RustDoc",
	styles = {
		RustDoc = require "codedocs.config.languages.rust.RustDoc",
	},
	targets = {
		func = {
			node_identifiers = {
				"function_item",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
