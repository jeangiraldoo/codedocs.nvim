return {
	func = {
		{
			structure = {
				"function foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				return_type = {},
			},
		},
		{
			structure = {
				"function foo() {",
				"    return 2;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				return_type = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
		{
			structure = {
				"function foo(a, b, c) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "",
					},
					{
						name = "b",
						type = "",
					},
					{
						name = "c",
						type = "",
					},
				},
				return_type = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
	},
	class = {
		{
			structure = {
				"class Foo {",
				"	a = '';",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {},
			},
		},
	},
}
