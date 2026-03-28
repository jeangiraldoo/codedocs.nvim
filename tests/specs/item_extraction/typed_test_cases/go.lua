local TYPES_TO_TEST = {
	"bool",
	"string",
	"int",
	"int8",
	"int16",
	"int32",
	"int64",
	"uint",
	"uint8",
	"uint16",
	"uint32",
	"uint64",
	"uintptr",
	"float32",
	"float64",
	"complex64",
	"complex128",
	"byte",
	"rune",
}

return {
	func = {
		returns = {
			template = {
				"func foo() %data_type {",
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
				"func foo(a %data_type) {",
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
