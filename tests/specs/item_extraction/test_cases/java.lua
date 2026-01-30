return {
	func = {
		{
			structure = {
				"public void foo() {",
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
				"public int foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {
					{
						name = "",
						type = "int",
					},
				},
			},
		},
		{
			structure = {
				"public int foo(int a, int b, int c) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {
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
				return_type = {
					{
						name = "",
						type = "int",
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
				'	public String a = "";',
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {},
			},
		},
	},
}
