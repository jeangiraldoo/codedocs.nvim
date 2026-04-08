local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local results = {}

	if struct_data.opts.attributes.static then
		local class_attrs = struct_data.lang_query_parser [[
			(class_body
				(public_field_definition
					"static"
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_attrs)
	end

	if struct_data.opts.attributes.instance == "constructor" then
		local constructor_node = struct_data.lang_query_parser([[
				(class_body
					(method_definition
						(property_identifier) @name
						(#eq? @name "constructor")) @target)
			]])[1]

		if constructor_node then
			local constructor_instance_attrs = struct_data.generic_query_parser(
				constructor_node,
				struct_data.lang_name,
				[[
						(assignment_expression
							(member_expression
								object: (this)
								property: (property_identifier) @item_name))
					]]
			)

			vim.list_extend(results, constructor_instance_attrs)
			return results
		end
	end

	if struct_data.opts.attributes.instance == "all" then
		local body_instance_attrs = struct_data.lang_query_parser [[
			(public_field_definition
				(property_identifier) @item_name
				(#not-match? @item_name "static"))
		]]

		local function_defined_instance_attrs = struct_data.lang_query_parser [[
			(assignment_expression
				(member_expression
					object: (this)
					property: (property_identifier) @item_name (#has-ancestor? @item_name method_definition)))
		]]

		vim.list_extend(results, body_instance_attrs)
		vim.list_extend(results, function_defined_instance_attrs)
	end

	return results
end

local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
				(formal_parameters
					(required_parameter
						(identifier) @item_name
						type: (type_annotation
							[
								(predefined_type)
								(array_type)
								(union_type)
								(generic_type)
								(tuple_type)
								(type_identifier)
								(literal_type)
								(object_type)
								(function_type)
							] @item_type )))
	]]
end

function Func_extractors.returns(struct_data)
	local items = struct_data.lang_query_parser [[
		[
			(method_definition
				return_type: (type_annotation
					[
						(predefined_type)
						(array_type)
						(union_type)
						(generic_type)
						(tuple_type)
						(type_identifier)
						(literal_type)
						(object_type)
						(function_type)
					] @item_type (#not-eq? @item_type "void")))
			(function_declaration
				return_type: (type_annotation
					[
						(predefined_type)
						(array_type)
						(union_type)
						(generic_type)
						(tuple_type)
						(type_identifier)
						(literal_type)
						(object_type)
						(function_type)
					] @item_type (#not-eq? @item_type "void")))
		]
	]]

	if #items > 0 then return items end

	return struct_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

---@alias CodedocsTSStyleNames
---| "TSDoc"

---@alias CodedocsTSStructNames
---| "class"
---| "func"
---| "comment"

---@class CodedocsTSStylesConfig: CodedocsLanguageStylesConfig
---@field definitions table<CodedocsTSStyleNames, table<CodedocsTSStructNames, CodedocsAnnotationStyleOpts>>
---@field default CodedocsTSStyleNames

---@class CodedocsTSConfig: CodedocsLanguageConfig
---@field styles CodedocsTSStylesConfig

---@type CodedocsTSConfig
return {
	lang_name = "typescript",
	styles = {
		default = "TSDoc",
		definitions = {
			TSDoc = require "codedocs.config.languages.typescript.TSDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"method_definition",
				"function_declaration",
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
					static = true,
					instance = "none",
				},
			},
		},
	},
}
