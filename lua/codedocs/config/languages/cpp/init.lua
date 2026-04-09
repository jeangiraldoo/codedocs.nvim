local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			(function_declarator
				(parameter_list
					(parameter_declaration
						type: [
							(primitive_type)
							(qualified_identifier)
							(struct_specifier
								(type_identifier))
							(sized_type_specifier)
							(type_identifier)
						] @item_type
						[
							(identifier)
							(pointer_declarator
								(identifier))
							(reference_declarator
								(identifier))
						] @item_name))))
	]]
end

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			type: [
				(primitive_type)
				(sized_type_specifier)
				(qualified_identifier)
				(type_identifier)
			] @item_type (#not-eq? @item_type "void"))
	]]
end

---@alias CodedocsCPPStyleNames
---| "Doxygen"

---@alias CodedocsCPPStructNames
---| "func"
---| "comment"

---@class CodedocsCPPConfig: CodedocsLanguageConfig
---@field default_style CodedocsCPPStyleNames
---@field styles table<CodedocsCPPStyleNames, table<CodedocsCPPStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsCPPConfig
return {
	default_style = "Doxygen",
	styles = {
		Doxygen = require "codedocs.config.languages.cpp.Doxygen",
	},
	targets = {
		func = {
			node_identifiers = {
				"function_definition",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
