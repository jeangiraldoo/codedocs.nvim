local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(function_item
			(parameters
				(parameter
					(identifier) @item_name
					[
						(type_identifier)
						(primitive_type)
					] @item_type)))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(function_item
			[
				(primitive_type)
				(type_identifier)
			] @item_type (#not-eq? @item_type "()"))
	]]
end

return {
	lang_name = "rust",
	default_style = "RustDoc",
	identifier_pos = true,
	supported_styles = {
		"RustDoc",
	},
	styles = {
		func = require "codedocs.lang_specs.rust.styles.func",
		comment = require "codedocs.lang_specs.rust.styles.comment",
	},
	struct_identifiers = {
		function_item = "func",
	},
	extractors = {
		func = Func_extractors,
	},
}
