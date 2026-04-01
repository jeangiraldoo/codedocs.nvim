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
	identifier_pos = true,
	styles = {
		default = "RustDoc",
		definitions = {
			RustDoc = require "codedocs.config.languages.rust.RustDoc",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"function_item",
			},
			extractors = Func_extractors,
		},
	},
}
