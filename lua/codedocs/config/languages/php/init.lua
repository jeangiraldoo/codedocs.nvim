local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		[
			(method_declaration
				(formal_parameters
					(simple_parameter
						(variable_name
							(name) @item_name))))
						type: [
							(primitive_type)
							(union_type)
							(named_type)
							(intersection_type)
							(disjunctive_normal_form_type)
						]? @item_type

			(function_definition
				(formal_parameters
					(simple_parameter
						(variable_name
							(name) @item_name))))
						type: [
							(primitive_type)
							(union_type)
							(named_type)
							(disjunctive_normal_form_type)
							(intersection_type)
						]? @item_type
		]
	]]
end

function Func_extractors.returns(struct_data)
	local items = struct_data.lang_query_parser [[
		(function_definition
			return_type: [
				(primitive_type)
				(union_type)
				(named_type)
				(bottom_type)
				(intersection_type)
				(disjunctive_normal_form_type)
			] @item_type )
	]]
	if #items > 0 then return items end

	return struct_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

---@alias CodedocsPHPStyleNames
---| "PHPDoc"

---@alias CodedocsPHPStructNames
---| "func"
---| "comment"

---@class CodedocsPHPStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsPHPStyleNames, table<CodedocsPHPStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsPHPStyleNames

---@class CodedocsPHPConfig: CodedocsLanguageConfig
---@field styles CodedocsPHPStylesConfig

---@type CodedocsPHPConfig
return {
	lang_name = "php",
	identifier_pos = false,
	styles = {
		default = "PHPDoc",
		definitions = {
			PHPDoc = require "codedocs.config.languages.php.PHPDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_definition",
				"method_declaration",
			},
			extractors = Func_extractors,
			opts = {},
		},
	},
}
