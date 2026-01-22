return {
	func = {
		---No parametres, no return
		{
			structure = {
				"function foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ",
					" *", ---BUG: shouln't have a title gap
					" */",
				},
			},
		},
		---No parametres, return
		{
			structure = {
				"function foo() {",
				"    return 2;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ",
					" *",
					" * @returns {}",
					" */",
				},
			},
		},
		---Parametres and return
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
