return {
	default_style = "KDoc",
	identifier_pos = true,
	styles = { KDoc = true },
	structs = {
		func = {
			node_identifiers = { "function_declaration" },
		},
		class = {
			node_identifiers = { "class_declaration" },
		},
	},
}
