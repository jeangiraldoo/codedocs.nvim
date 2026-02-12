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
				returns = {},
			},
		},
		{
			structure = {
				"function foo(): number {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				returns = {
					{
						name = "",
						type = "number",
					},
				},
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
				returns = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
		{
			structure = {
				"function foo(a: number, b: number, c: number) {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "number",
					},
					{
						name = "b",
						type = "number",
					},
					{
						name = "c",
						type = "number",
					},
				},
				returns = {},
			},
		},
		{
			structure = {
				"function foo(a: number, b: number, c: number) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "number",
					},
					{
						name = "b",
						type = "number",
					},
					{
						name = "c",
						type = "number",
					},
				},
				returns = {
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
				"	a: String;",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {},
			},
		},
	},
}
