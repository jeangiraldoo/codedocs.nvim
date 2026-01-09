return {
	default_style = "TSDoc",
	identifier_pos = true,
	styles = { TSDoc = true },
	structs = {
		func = {
			node_identifiers = { "method_definition", "function_declaration" },
		},
		class = {
			node_identifiers = { "class_declaration" },
		},
	},
}
