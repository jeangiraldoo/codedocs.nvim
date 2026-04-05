local TYPES_TO_TEST = {
	"number",
	"string",
	"boolean",
	"unknown",
	"any",
	"never",
	"object",
	"symbol",
	"bigint",
	"null",
	"undefined",
	"Number",
	"String",
	"Boolean",
	"Symbol",
	"BigInt",
	"Object",
	"Int8Array",
	"Uint8Array",
	"Uint8ClampedArray",
	"Int16Array",
	"Uint16Array",
	"Int32Array",
	"Uint32Array",
	"Float32Array",
	"Float64Array",
	"BigInt64Array",
	"BigUint64Array",
}

local COLLECTIONS_WITH_GENERICS = {
	"number | %data_type",
	"Array<%data_type>",
	"%data_type[]",
	"[number, %data_type]",
	"Record<number, %data_type>",
	"Map<number, %data_type>",
	"WeakMap<number, %data_type>",
	"Set<%data_type>",
	"WeakSet<%data_type>",
	"{ x: number, y: %data_type }",
	"Iterable<%data_type>",
	"Iterator<%data_type>",
	"Promise<%data_type>",
	"PromiseLike<%data_type>",
	"Partial<%data_type>",
	"(a: %data_type) => number",
	"(a: number) => %data_type",
}

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
