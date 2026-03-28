local TYPES_TO_TEST = {
	"number",
	"string",
	"boolean",
	"unknown",
	"any",
	"never",
	"object",
	"symbol",
}

local COLLECTIONS_WITH_GENERICS = {}

return {
	func = {
		returns = {
			template = {
				"function foo(): %data_type {",
				"}",
			},
			cursor_pos = {
				row = 2,
				col = 1,
			},
			expected_item_name = "",
			types_to_test = (function()
				local returns_only_types = {}

				local types_copy = vim.deepcopy(TYPES_TO_TEST)
				vim.list_extend(types_copy, returns_only_types)
				return types_copy
			end)(),
			collections_with_generics = (function()
				local generics_only_types = {
					"%data_type[]",
				}

				local types_copy = vim.deepcopy(COLLECTIONS_WITH_GENERICS)
				vim.list_extend(types_copy, generics_only_types)
				return types_copy
			end)(),
		},
		parameters = {
			template = {
				"function foo(a: %data_type): void {",
				"}",
			},
			cursor_pos = {
				row = 2,
				col = 1,
			},
			expected_item_name = "a",
			types_to_test = (function()
				local parametre_only_types = {
					"void",
				}

				local types_copy = vim.deepcopy(TYPES_TO_TEST)
				vim.list_extend(types_copy, parametre_only_types)
				return types_copy
			end)(),
			collections_with_generics = (function()
				local collections_only_types = {}

				local types_copy = vim.deepcopy(COLLECTIONS_WITH_GENERICS)
				vim.list_extend(types_copy, collections_only_types)
				return types_copy
			end)(),
		},
	},
}
