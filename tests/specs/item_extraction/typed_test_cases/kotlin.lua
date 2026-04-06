local TYPES_TO_TEST = {
	"Char",
	"String",
	"Int",
	"Long",
	"Short",
	"Byte",
	"UInt",
	"ULong",
	"UShort",
	"UByte",
	"Float",
	"Double",
	"Boolean",

	"CharArray",
	"IntArray",
	"LongArray",
	"ShortArray",
	"FloatArray",
	"DoubleArray",
	"ByteArray",
	"BooleanArray",

	"Any",
	"Nothing",

	"IntProgression",
	"LongProgression",
	"CharProgression",

	"IntRange",
	"UIntRange",
	"LongRange",
	"ULongRange",
	"CharRange",
	"ClosedFloatingPointRange",
}

local COLLECTIONS_WITH_GENERICS = {
	"Array<%data_type>",

	"List<%data_type>",
	"MutableList<%data_type>",

	"Set<%data_type>",
	"MutableSet<%data_type>",

	"Sequence<%data_type>",
	"Map<String, %data_type>",

	"(Int) -> %data_type",
	"(%data_type) -> Int",

	"Iterable<%data_type>",

	"Pair<int, %data_type>",
	"Triple<int, String, %data_type>",
}

return {
	func = {
		returns = {
			template = {
				"fun foo(): %data_type {",
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
				"fun foo(a: %data_type): Unit {",
				"}",
			},
			cursor_pos = {
				row = 1,
				col = 1,
			},
			expected_item_name = "a",
			types_to_test = (function()
				local parametre_only_types = {
					"Unit", --- The `Unit` data type is ignored in the `returns` section
				}

				local types_copy = vim.deepcopy(TYPES_TO_TEST)
				vim.list_extend(types_copy, parametre_only_types)
				return types_copy
			end)(),
			collections_with_generics = COLLECTIONS_WITH_GENERICS,
		},
	},
}
