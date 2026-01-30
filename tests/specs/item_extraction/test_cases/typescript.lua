return {
	func = {
		{
			structure = {
				"function foo() {",
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
				"function foo(): number {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {
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
				params = {},
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
				"function foo(a: number, b: number, c: number) {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {
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
				return_type = {},
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
				params = {
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
