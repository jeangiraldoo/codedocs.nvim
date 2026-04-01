local Func_extractors = {}

function Func_extractors.parameters(struct_data)
	return struct_data.lang_query_parser [[
		(method
			(method_parameters
				(identifier) @item_name))
	]]
end

function Func_extractors.returns(struct_data)
	return struct_data.lang_query_parser [[
		(return
			(_) @item_type
			(#set! parse_as_blank "true"))
	]]
end

return {
	lang_name = "ruby",
	identifier_pos = true,
	styles = {
		default = "YARD",
		definitions = {
			YARD = require "codedocs.config.languages.ruby.YARD",
		},
	},
	structures = {
		func = {
			node_identifiers = {
				"method",
			},
			extractors = Func_extractors,
		},
	},
}
