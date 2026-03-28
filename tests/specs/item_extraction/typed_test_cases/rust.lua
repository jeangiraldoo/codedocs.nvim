local TYPES_TO_TEST = {
	"i8",
	"i16",
	"i32",
	"i64",
	"i128",
	"isize",
	"u8",
	"u16",
	"u32",
	"u64",
	"u128",
	"usize",
	"f32",
	"f64",
	"bool",
	"char",
	"String",
	"str",
}

local COLLECTIONS_WITH_GENERICS = {}

return {
	func = {
		returns = {
			template = {
				"fn foo() -> %data_type {",
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
			collections_with_generics = COLLECTIONS_WITH_GENERICS,
		},
		parameters = {
			template = {
				"fn foo(a: %data_type) {",
				"}",
			},
			cursor_pos = {
				row = 2,
				col = 1,
			},
			expected_item_name = "a",
			types_to_test = (function()
				local parametre_only_types = {}

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
