local TYPES_TO_TEST = {
	"char",
	"int",
	"float",
	"double",
	"bool",
	"short",
	"short int",

	"long",
	"long int",
	"long long",
	"long long int",
	"long double",

	"wchar_t",
	"char8_t",
	"char16_t",
	"char32_t",

	"int8_t",
	"int16_t",
	"int32_t",
	"int64_t",

	"uint8_t",
	"uint16_t",
	"uint32_t",
	"uint64_t",

	"intptr_t",
	"uintptr_t",
	"intmax_t",
	"uintmax_t",
}

local COLLECTIONS_WITH_GENERICS = {
	"signed %data_type",
	"unsigned %data_type",
	"std::vector<%data_type>",
	"std::array<%data_type, std::string>",
	"std::map<std::string, %data_type>",
	"std::unordered_map<K, %data_type>",
	"std::set<%data_type>",
	"std::unordered_set<%data_type>",
	"std::deque<%data_type>",
	"std::list<%data_type>",
}

return {
	func = {
		generic = {
			{
				structure = {
					"void foo() {",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
		},
		blocks = {
			returns = {
				generic = {},
				typed_cases = {
					template = {
						"%data_type foo() {",
						"}",
					},
					cursor_pos = { row = 1, col = 1 },
					expected_item_name = "",
					types_to_test = TYPES_TO_TEST,
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
			parameters = {
				generic = {
					{
						structure = {
							"int add(int a, int b, int c) {",
							"    return a + b",
							"}",
						},
						cursor_pos = { row = 1, col = 1 },
						expected_items = {
							parameters = {
								{ name = "a", type = "int" },
								{ name = "b", type = "int" },
								{ name = "c", type = "int" },
							},
							returns = {
								{ name = "", type = "int" },
							},
						},
					},
				},
				typed_cases = {
					template = {
						"void foo(%data_type a) {",
						"}",
					},
					cursor_pos = { row = 1, col = 1 },
					expected_item_name = "a",
					types_to_test = TYPES_TO_TEST,
					collections_with_generics = COLLECTIONS_WITH_GENERICS,
				},
			},
		},
	},
}
