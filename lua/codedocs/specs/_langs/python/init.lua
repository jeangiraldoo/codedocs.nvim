return {
	default_style = "reST",
	identifier_pos = true,
	styles = { Google = true, Numpy = true, reST = true },
	structs = {
		func = {
			node_identifiers = { "function_definition" },
		},
		class = {
			node_identifiers = { "class_definition" },
		},
	},
}
