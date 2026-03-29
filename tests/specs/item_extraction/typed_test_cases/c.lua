local TYPES_TO_TEST = {
	"char",
	"int",
	"float",
	"double",
	"bool",
}

return {
	func = {
		returns = {
			template = {
				"%data_type foo() {",
				"}",
			},
			cursor_pos = {
				row = 1,
				col = 1,
			},
			expected_item_name = "",
			types_to_test = TYPES_TO_TEST,
		},
		parameters = {
			template = {
				"void foo(%data_type a) {",
				"}",
			},
			cursor_pos = {
				row = 1,
				col = 1,
			},
			expected_item_name = "a",
			types_to_test = TYPES_TO_TEST,
		},
	},
}
