local Class_extractors = {}

function Class_extractors.attributes(struct_data)
	local settings = struct_data.style.settings.item_extraction.attributes
	local results = {}
	if settings.static then
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

	if settings.instance == "all" then
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
					(_) @item_type
					(identifier) @item_name)))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(method_declaration
			(integral_type) @item_type (#not-eq? @item_type "void"))
	]]
end

return {
	lang_name = "java",
	default_style = "JavaDoc",
	identifier_pos = false,
	supported_styles = {
		"JavaDoc",
	},
	styles = {
		func = require "codedocs.lang_specs.java.styles.func",
		class = require "codedocs.lang_specs.java.styles.class",
		comment = require "codedocs.lang_specs.java.styles.comment",
	},
	extraction = {
		struct_identifiers = {
			method_declaration = "func",
			class_declaration = "class",
		},
		extractors = {
			class = Class_extractors,
			func = Func_extractors,
		},
	},
}
