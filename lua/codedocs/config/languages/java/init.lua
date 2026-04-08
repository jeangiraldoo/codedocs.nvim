local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	-- local settings = struct_data.style.settings.item_extraction.attributes
	local results = {}
	if struct_data.opts.attributes.static then
		local class_attrs = struct_data.lang_query_parser [[
			(class_body
				(field_declaration
					(modifiers) @name (#match? @name "static")
					(type_identifier) @item_type
					(variable_declarator
						(identifier) @item_name)))
		]]
		vim.list_extend(results, class_attrs)
	end

	if struct_data.opts.attributes.instance == "all" then
		local instance_attrs = struct_data.lang_query_parser [[
			(class_body
				(field_declaration
					(modifiers) @name
					(#not-match? @name "static")
					(type_identifier) @item_type
					(variable_declarator
						(identifier) @item_name)))
		]]
		vim.list_extend(results, instance_attrs)
	end

	return results
end

local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(method_declaration
			(formal_parameters
				(formal_parameter
					type: [
						(integral_type)
						(floating_point_type)
						(generic_type)
						(boolean_type)
						(type_identifier)
						(array_type)
					] @item_type
					name: (identifier) @item_name)))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(method_declaration
			type: [
				(integral_type)
				(floating_point_type)
				(generic_type)
				(boolean_type)
				(type_identifier)
				(array_type)
			 ] @item_type (#not-eq? @item_type "void"))
	]]
end

---@alias CodedocsJavaStyleNames
---| "JavaDoc"

---@alias CodedocsJavaStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsJavaStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsJavaStyleNames, table<CodedocsJavaStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsJavaStyleNames

---@class CodedocsJavaConfig: CodedocsLanguageConfig
---@field styles CodedocsJavaStylesConfig

---@type CodedocsJavaConfig
return {
	lang_name = "java",
	styles = {
		default = "JavaDoc",
		definitions = {
			JavaDoc = require "codedocs.config.languages.java.JavaDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"method_declaration",
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
					instance = "none", -- Java attrs can only be declared in the class body
				},
			},
		},
	},
}
