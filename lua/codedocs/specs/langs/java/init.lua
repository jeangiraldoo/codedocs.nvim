return {
	default_style = "JavaDoc",
	identifier_pos = false,
	styles = {JavaDoc = true},
	structs = {
		func = {
			node_identifiers = {"method_declaration"}
		},
		class = {
			node_identifiers = {"class_declaration"}
		},
	}
}
