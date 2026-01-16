return {
	default_style = "JSDoc",
	identifier_pos = true,
	styles = { JSDoc = true },
	structs = {
		func = {
			node_identifiers = {
				"method_definition",
				"function_declaration",
			},
		},
		class = {
			node_identifiers = { "class_declaration" },
		},
	},
}
