local Class_extractors = {}

function Class_extractors.attributes(target_data)
	local results = {}

	if target_data.opts.attributes.static then
		local class_attrs = target_data.lang_query_parser [[
			(companion_object
				(class_body
					(property_declaration
						(variable_declaration
							(simple_identifier) @item_name
							(user_type) @item_type))))
		]]

		vim.list_extend(results, class_attrs)
	end

	if target_data.opts.attributes.instance == "constructor" then
		local constructor_instance_attrs = target_data.lang_query_parser [[
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

	if target_data.opts.attributes.instance == "all" then
		local all_instance_attrs = target_data.lang_query_parser [[
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

function Func_extractors.parameters(target_data)
	return target_data.lang_query_parser [[
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

function Func_extractors.returns(target_data)
	return target_data.lang_query_parser [[
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

---@class CodedocsKotlinConfig: CodedocsLanguageConfig
---@field default_style CodedocsKotlinStyleNames
---@field styles table<CodedocsKotlinStyleNames, table<CodedocsKotlinStructNames, CodedocsAnnotationStyleOpts>>

---@type CodedocsKotlinConfig
return {
	default_style = "KDoc",
	styles = {
		KDoc = require "codedocs.config.languages.kotlin.KDoc",
	},
	targets = {
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
