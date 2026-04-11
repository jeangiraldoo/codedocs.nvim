local TYPES_TO_TEST = {
	"int",
	"float",
	"bool",
	"string",
	"void",
	"null",
	"mixed",
	"object",
	"callable",
	"array",
	"iterable",
	"mixed",
	"callable",
	"iterable",
	"never",
	"true",
	"false",
	"resource",
	"(A&B)",
}

local COLLECTIONS_WITH_GENERICS = {
	"int | %data_type",
}

return {
	func = {
		generic = {
			{
				structure = {
					"<?php",
					"function add()",
					"{",
					"}",
					"?>",
				},
				cursor_pos = { row = 3, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
			{
				structure = {
					"<?php",
					"function add(int $a, int $b, int $c): int",
					"{",
					"	return $a;",
					"}",
					"?>",
				},
				cursor_pos = { row = 3, col = 1 },
				expected_items = {
					parameters = {
						{
							name = "a",
							type = "int",
						},
						{
							name = "b",
							type = "int",
						},
						{
							name = "c",
							type = "int",
						},
					},
					returns = {
						{
							name = "",
							type = "int",
						},
					},
				},
			},
		},
		blocks = {
			returns = {
				generic = {
					{
						structure = {
							"<?php",
							"function add()",
							"{",
							"	return 2",
							"}",
							"?>",
						},
						cursor_pos = { row = 3, col = 1 },
						expected_items = {
							parameters = {},
							returns = {
								{ name = "", type = "" },
							},
						},
					},
				},
				typed_cases = {
					template = {
						"<?php",
						"function foo(): %data_type {",
						"}",
					},
					cursor_pos = { row = 2, col = 1 },
					expected_item_name = "",
					types_to_test = (function()
						local returns_only_types = {}

						local types_copy = vim.deepcopy(TYPES_TO_TEST)
						vim.list_extend(types_copy, returns_only_types)
						return types_copy
					end)(),
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
			parameters = {
				generic = {
					{
						structure = {
							"<?php",
							"function add(int $a, int $b, int $c)",
							"{",
							"}",
							"?>",
						},
						cursor_pos = { row = 3, col = 1 },
						expected_items = {
							parameters = {
								{ name = "a", type = "int" },
								{ name = "b", type = "int" },
								{ name = "c", type = "int" },
							},
							returns = {},
						},
					},
				},
				typed_cases = {
					template = {
						"<?php",
						"function foo(%data_type $a): void {",
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
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
		},
	},
}
