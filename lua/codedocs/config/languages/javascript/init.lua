local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local settings = struct_data.style.settings.item_extraction.attributes
	local results = {}

	if settings.static then
		local class_attrs = struct_data.lang_query_parser [[
			(class_body
				(field_definition
					"static"
					(property_identifier) @item_name))
		]]

		vim.list_extend(results, class_attrs)
	end

	if settings.instance == "constructor" then
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
								(property_identifier) @item_name))
					]]
			)

			vim.list_extend(results, constructor_instance_attrs)
		end
		return results
	end

	if settings.instance == "all" then
		local class_body_instance_attrs = struct_data.lang_query_parser [[
			(class_body
				(field_definition
					property: (property_identifier) @item_name) @field (#not-match? @field "static"))
		]]

		local function_defined_instance_attrs = struct_data.lang_query_parser [[
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

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
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

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(return_statement
			(_) @item_type (#set! parse_as_blank "true"))
	]]
end

return {
	lang_name = "javascript",
	identifier_pos = true,
	styles = {
		default = "JSDoc",
		definitions = {
			JSDoc = require "codedocs.config.languages.javascript.JSDoc",
		},
	},
	extraction = {
		struct_identifiers = {
			method_definition = "func",
			function_declaration = "func",
			arrow_function = "func",
			class_declaration = "class",
		},
		extractors = {
			class = Class_extractors,
			func = Func_extractors,
		},
	},
}
