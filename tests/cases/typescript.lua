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
				TSDoc = {
					"/**",
					" * ",
					" */",
				},
			},
		},
		---Only explicit return type
		{
			structure = {
				"function foo(): number {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ",
					" *",
					" * @returns",
					" */",
				},
			},
		},
		---Only return statement
		{
			structure = {
				"function foo() {",
				"    return 2;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ",
					" *",
					" * @returns",
					" */",
				},
			},
		},
		---Only parametres
		{
			structure = {
				"function foo(a: number, b: number, c: number) {",
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
					" */",
				},
			},
		},
		---Parametres and return
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
					" */",
				},
			},
		},
	},
}
