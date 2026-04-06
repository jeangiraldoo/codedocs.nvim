local TYPES_TO_TEST = {
	"char",
	"byte",
	"short",
	"int",
	"long",
	"float",
	"double",
	"Byte",
	"Short",
	"Integer",
	"Long",
	"Float",
	"Double",
	"Character",
	"Boolean",
	"String",
	"Object",
	"boolean",
}

local COLLECTIONS_WITH_GENERICS = {
	"%data_type[]",
	"List<%data_type>",
	"ArrayList<%data_type>",
	"LinkedList<%data_type>",

	"Set<%data_type>",
	"HashSet<%data_type>",
	"TreeSet<%data_type>",

	"Map<String, %data_type>",
	"HashMap<String, %data_type>",

	"Queue<%data_type>",
}

return {
	func = {
		returns = {
			template = {
				"public %data_type foo() {",
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
				"public void foo(%data_type a) {",
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
