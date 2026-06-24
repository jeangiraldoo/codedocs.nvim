return {
	node_identifiers = {
		"class_declaration",
	},
	extractors = {},
	opts = {
		attributes = {
			static = false,
			instance = "none", -- Java attrs can only be declared in the class body
		},
	},
}
