return {
	func = {
		{
			structure = {
				"fun foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"fun foo(): Unit {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"fun foo(): int {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {
					{
						type = "int",
					},
				},
			},
		},
		{
			structure = {
				"fun foo(a: Int, b: Int, c: Int): Int {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {
					{
						name = "a",
						type = "Int",
					},
					{
						name = "b",
						type = "Int",
					},
					{
						name = "c",
						type = "Int",
					},
				},
				return_type = {
					{
						type = "Int",
					},
				},
			},
		},
	},
	class = {
		{
			structure = {
				"public class Foo {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {},
			},
		},
		{
			structure = {
				"public class Foo {",
				'	var a: String = "";',
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {},
			},
		},
	},
}
