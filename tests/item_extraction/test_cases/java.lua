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
		generic = {
			{
				structure = {
					"public void foo() {",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
			{
				structure = {
					"public int foo(int a, int b, int c) {",
					"    return a;",
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
		blocks = {
			returns = {
				generic = {},
				typed_cases = {
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
			},
			parameters = {
				generic = {},
				typed_cases = {
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
		},
	},
	class = {
		generic = {
			{
				structure = {
					"public class Foo {",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					attributes = {},
				},
			},
			{
				structure = {
					"public class Foo {",
					'	public String a = "";',
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					attributes = {},
				},
			},
		},
	},
}
