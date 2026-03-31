local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local settings = struct_data.style.settings.item_extraction.attributes
	local results = {}

	if settings.static then
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

	if settings.instance == "constructor" then
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

	if settings.instance == "all" then
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
					(user_type) @item_type)))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_declaration
			(user_type) @item_type (#not-eq? @item_type "Unit"))
	]]
end

return {
	lang_name = "kotlin",
	identifier_pos = true,
	supported_styles = {
		"KDoc",
	},
	styles = {
		default = "KDoc",
		definitions = {
			func = require "codedocs.lang_specs.kotlin.styles.func",
			class = require "codedocs.lang_specs.kotlin.styles.class",
			comment = require "codedocs.lang_specs.kotlin.styles.comment",
		},
	},
	extraction = {
		struct_identifiers = {
			function_declaration = "func",
			class_declaration = "class",
		},
		extractors = {
			class = Class_extractors,
			func = Func_extractors,
		},
	},
}
