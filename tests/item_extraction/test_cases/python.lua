local TYPES_TO_TEST = {
	"int",
	"float",
	"complex",
	"bool",
	"str",
	"bytes",
	"Any",
	"object",
	"list",
}

local COLLECTIONS_WITH_GENERICS = {
	"list[%data_type]",
	"set[%data_type]",
	"frozenset[%data_type]",
	"dict[int, %data_type]",
	"tuple[int, %data_type]",
	"Iterator[%data_type]",
	"Generator[str, int, %data_type]",
	"Callable[[int, %data_type], bool]",
	"Literal[int, %data_type]",
	"Sequence[%data_type]",
	"MutableSequence[%data_type]",
	"Mapping[int, %data_type]",
	"MutableMapping[int, %data_type]",
	"int | %data_type",
	"Union[int, %data_type]",
	"Optional[%data_type]",
}

return {
	func = {
		generic = {
			{
				structure = {
					"def foo():",
					"	pass",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
			{
				structure = {
					"def foo(a, b, c):",
					"	return a",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {
						{ name = "a", type = "" },
						{ name = "b", type = "" },
						{ name = "c", type = "" },
					},
					returns = {
						{ name = "", type = "" },
					},
				},
			},
		},
		blocks = {
			returns = {
				generic = {},
				typed_cases = {
					template = {
						"def foo() -> %data_type:",
						"	...",
					},
					cursor_pos = { row = 2, col = 1 },
					expected_item_name = "",
					types_to_test = TYPES_TO_TEST,
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
			parameters = {
				generic = {},
				typed_cases = {
					template = {
						"def foo(a: %data_type):",
						"	...",
					},
					cursor_pos = { row = 2, col = 1 },
					expected_item_name = "a",
					types_to_test = (function()
						local parametre_only_types = {
							"None",
						}

						local types_copy = vim.deepcopy(TYPES_TO_TEST)
						vim.list_extend(types_copy, parametre_only_types)
						return types_copy
					end)(),
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
		},
	},
	class = {
		generic = {
			{
				structure = {
					"class Foo:",
					'	a = ""',
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					attributes = {
						{ name = "a", type = "" },
					},
				},
			},
		},
	},
}
