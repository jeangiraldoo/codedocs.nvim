local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(function_definition
			(function_declarator
				(parameter_list
					(parameter_declaration
						[
							(primitive_type)
							(struct_specifier
								(type_identifier))
						] @item_type
						[
							(identifier)
							(pointer_declarator
								(identifier))
						] @item_name))))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_definition
			(primitive_type) @item_type (#not-eq? @item_type "void"))
	]]
end

---@alias CodedocsCStyleNames
---| "Doxygen"

---@alias CodedocsCStructNames
---| "func"
---| "comment"

---@class CodedocsCStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsCStyleNames, table<CodedocsCStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsCStyleNames

---@class CodedocsCConfig: CodedocsLanguageConfig
---@field styles CodedocsCStylesConfig

---@type CodedocsCConfig
return {
	lang_name = "c",
	identifier_pos = false,
	styles = {
		default = "Doxygen",
		definitions = {
			Doxygen = require "codedocs.config.languages.c.Doxygen",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_definition",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
