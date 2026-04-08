local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		parameters: (formal_parameters
			(simple_parameter
				type: [
				  (primitive_type) @item_type
				  (union_type) @item_type
				  (named_type) @item_type
				  (disjunctive_normal_form_type) @item_type
				  (intersection_type) @item_type
				]?
				name: (variable_name
					(name) @item_name)))
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

---@class CodedocsPHPConfig: CodedocsLanguageConfig
---@field default_style CodedocsPHPStyleNames
---@field styles table<CodedocsPHPStyleNames, table<CodedocsPHPStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsPHPConfig
return {
	default_style = "PHPDoc",
	styles = {
		PHPDoc = require "codedocs.config.languages.php.PHPDoc",
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
