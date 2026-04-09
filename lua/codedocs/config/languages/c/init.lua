local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			(function_declarator
				(parameter_list
					(parameter_declaration
						type: [
							(sized_type_specifier)
							(primitive_type)
							(struct_specifier
								(type_identifier))
							(type_identifier)
						] @item_type
						[
							(identifier)
							(pointer_declarator
								(identifier))
						] @item_name))))
	]]
end

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(function_definition
			type: [
				(sized_type_specifier)
				(primitive_type)
				(type_identifier)
			] @item_type (#not-eq? @item_type "void"))
	]]
end

---@alias CodedocsCStyleNames
---| "Doxygen"

---@alias CodedocsCStructNames
---| "func"
---| "comment"

---@class CodedocsCConfig: CodedocsLanguageConfig
---@field default_style CodedocsCStyleNames
---@field styles table<CodedocsCStyleNames, table<CodedocsCStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsCConfig
return {
	default_style = "Doxygen",
	styles = {
		Doxygen = require "codedocs.config.languages.c.Doxygen",
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
