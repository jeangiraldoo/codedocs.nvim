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
	"error",
	"any",
}

local COLLECTIONS_WITH_GENERICS = {
	"[]%data_type",
	"[10]%data_type",
	"map[string]%data_type",
	"func(int) %data_type",
	"func(%data_type) int",
	"chan %data_type",
	"<-chan %data_type",
	"chan<- %data_type",
	"*%data_type",
	"struct{x %data_type}",
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
			collections_with_generics = COLLECTIONS_WITH_GENERICS,
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
			collections_with_generics = COLLECTIONS_WITH_GENERICS,
		},
	},
}
