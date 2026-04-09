local Class_extractors = {}

function Class_extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(class_body
				(field_definition
					"static"
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_node = target_data.lang_query_parser([[
				(class_body
					(method_definition
						(property_identifier) @name
						(#eq? @name "constructor")) @target)
			]])[1]

		if constructor_node then
			local constructor_instance_attrs = target_data.generic_query_parser(
				constructor_node,
				target_data.lang_name,
				[[
						(assignment_expression
							(member_expression
								(property_identifier) @item_name))
					]]
			)

			vim.list_extend(results, constructor_instance_attrs)
		end
		return results
	end

	if target_data.opts.attributes.instance == "all" then
		local class_body_instance_attrs = target_data.lang_query_parser [[
			(class_body
				(field_definition
					property: (property_identifier) @item_name) @field (#not-match? @field "static"))
		]]

		local function_defined_instance_attrs = target_data.lang_query_parser [[
			(assignment_expression
				(member_expression
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_body_instance_attrs)
		vim.list_extend(results, function_defined_instance_attrs)
	end

	return results
end

local Func_extractors = {}

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
		[
			(method_definition
				(formal_parameters
					(identifier) @item_name
				)
			)
			(function_declaration
				(formal_parameters
					(identifier) @item_name
				)
			)
			(arrow_function
				parameters: (formal_parameters
					(identifier) @item_name))
		]
	]]
end

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

---@alias CodedocsJSStyleNames
---| "JSDoc"

---@alias CodedocsJSStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsJSConfig: CodedocsLanguageConfig
---@field default_style CodedocsJSStyleNames
---@field styles table<CodedocsJSStyleNames, table<CodedocsJSStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsJSConfig
return {
	default_style = "JSDoc",
	styles = {
		JSDoc = require "codedocs.config.languages.javascript.JSDoc",
	},
	targets = {
		func = {
			node_identifiers = {
				"method_definition",
				"function_declaration",
				"arrow_function",
			},
			extractors = Func_extractors,
			opts = {},
		},
		class = {
			node_identifiers = {
				"class_declaration",
			},
			extractors = Class_extractors,
			opts = {
				attributes = {
					static = false,
					instance = "none",
				},
			},
		},
	},
}
