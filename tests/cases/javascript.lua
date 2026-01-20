return {
	func = {
		{
			structure = {
				"function foo(a, b, c) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ",
					" *",
					" * @param {} a",
					" * @param {} b",
					" * @param {} c",
					" * @returns {}",
					" */",
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
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ",
					" *",
					" */",
				},
			},
		},
	},
}
