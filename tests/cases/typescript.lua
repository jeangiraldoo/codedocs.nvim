return {
	func = {
		{
			structure = {
				"function foo(a: number, b: number, c: number) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ",
					" *",
					" * @param a -",
					" * @param b -",
					" * @param c -",
					" * @returns",
					" */",
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
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ",
					" *",
					" * Properties:",
					" */",
				},
			},
		},
	},
}
