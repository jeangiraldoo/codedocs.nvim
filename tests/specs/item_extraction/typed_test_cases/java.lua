local TYPES_TO_TEST = {
	"char",
	"byte",
	"short",
	"int",
	"long",
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
			types_to_test = (function()
				local parametre_only_types = { --- None of these data types are supported in the returns section
					"float",
					"double",
					"String",
					"Float",
					"Double",
					"Integer",
					"Long",
					"Boolean",
					"Character",
					"Byte",
					"Short",
					"boolean",
				}

				local types_copy = vim.deepcopy(TYPES_TO_TEST)
				vim.list_extend(types_copy, parametre_only_types)
				return types_copy
			end)(),
			collections_with_generics = {
				"List<%data_type>",
				"ArrayList<%data_type>",
				"LinkedList<%data_type>",
				"Set<%data_type>",
				"HashSet<%data_type>",
				"TreeSet<%data_type>",
			},
		},
	},
}
