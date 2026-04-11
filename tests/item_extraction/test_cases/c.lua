local TYPES_TO_TEST = {
	"char",
	"int",
	"float",
	"short",

	"bool",
	"_Bool",

	"double",
	"long double",

	"long",
	"long long",
	"long int",
	"long long int",

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

	"size_t",
}

local COLLECTIONS_WITH_GENERICS = {
	"signed %data_type",
	"unsigned %data_type",
}

return {
	func = {
		generic = {},
		blocks = {
			returns = {
				generic = {},
				typed_cases = {
					template = {
						"%data_type foo() {",
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
			},
			parameters = {
				generic = {
					{
						structure = {
							"void add(int a, int b, int c) {",
							"}",
						},
						cursor_pos = {
							row = 1,
							col = 1,
						},
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
							returns = {},
						},
					},
				},
				typed_cases = {
					template = {
						"void foo(%data_type a) {",
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
		},
	},
}
