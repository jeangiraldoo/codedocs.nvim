local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		[
			(method_declaration
				(formal_parameters
					(simple_parameter
						(primitive_type)? @item_type
						(variable_name
							(name) @item_name))))
			(function_definition
				(formal_parameters
					(simple_parameter
						(primitive_type)? @item_type
						(variable_name
							(name) @item_name))))
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
	lang_name = "php",
	default_style = "PHPDoc",
	identifier_pos = false,
	supported_styles = {
		"PHPDoc",
	},
	styles = {
		definitions = {
			func = require "codedocs.lang_specs.php.styles.func",
			comment = require "codedocs.lang_specs.php.styles.comment",
		},
	},
	extraction = {
		struct_identifiers = {
			function_definition = "func",
			method_declaration = "func",
		},
		extractors = {
			func = Func_extractors,
		},
	},
}
