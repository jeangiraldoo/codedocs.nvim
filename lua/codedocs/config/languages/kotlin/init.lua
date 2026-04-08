local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local results = {}

	if struct_data.opts.attributes.static then
		local class_attrs = struct_data.lang_query_parser [[
			(companion_object
				(class_body
					(property_declaration
						(variable_declaration
							(simple_identifier) @item_name
							(user_type) @item_type))))
		]]

		vim.list_extend(results, class_attrs)
	end

	if struct_data.opts.attributes.instance == "constructor" then
		local constructor_instance_attrs = struct_data.lang_query_parser [[
				(class_declaration
					(primary_constructor
						(class_parameter
							(binding_pattern_kind)
							(simple_identifier) @item_name
							(user_type) @item_type)))
			]]

		vim.list_extend(results, constructor_instance_attrs)
		return results
	end

	if struct_data.opts.attributes.instance == "all" then
		local all_instance_attrs = struct_data.lang_query_parser [[
			(class_declaration
				[
					(class_body
						(property_declaration
							(variable_declaration
								(simple_identifier) @item_name
								(user_type) @item_type)))
					(primary_constructor
						(class_parameter
							(binding_pattern_kind)
							(simple_identifier) @item_name
							(user_type) @item_type))
				])
		]]

		vim.list_extend(results, all_instance_attrs)
	end

	return results
end

local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(function_declaration
			(function_value_parameters
				(parameter
					(simple_identifier) @item_name
					[
						(user_type)
						(function_type)
					] @item_type)))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_declaration
			[
				(user_type)
				(function_type)
			] @item_type (#not-eq? @item_type "Unit"))
	]]
end

---@alias CodedocsKotlinStyleNames
---| "KDoc"

---@alias CodedocsKotlinStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsKotlinStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsKotlinStyleNames, table<CodedocsKotlinStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsKotlinStyleNames

---@class CodedocsKotlinConfig: CodedocsLanguageConfig
---@field styles CodedocsKotlinStylesConfig

---@type CodedocsKotlinConfig
return {
	lang_name = "kotlin",
	styles = {
		default = "KDoc",
		definitions = {
			KDoc = require "codedocs.config.languages.kotlin.KDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_declaration",
			},
			extractors = Func_extractors,
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
