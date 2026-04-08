local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
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

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
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

---@class CodedocsRustStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsRustStyleNames, table<CodedocsRustStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsRustStyleNames

---@class CodedocsRustConfig: CodedocsLanguageConfig
---@field styles CodedocsRustStylesConfig

---@type CodedocsRustConfig
return {
	lang_name = "rust",
	styles = {
		default = "RustDoc",
		definitions = {
			RustDoc = require "codedocs.config.languages.rust.RustDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_item",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
