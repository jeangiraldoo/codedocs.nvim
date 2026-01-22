return {
	func = {
		---No parametres, no return
		{
			structure = {
				"void foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"/**",
					" * ",
					" */",
				},
			},
		},
		---Only return type
		{
			structure = {
				"int foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"/**",
					" * ",
					" *",
					" * @return",
					" */",
				},
			},
		},
		---Parametres and return
		{
			structure = {
				"int add(int a, int b, int c) {",
				"    return a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"/**",
					" * ",
					" *",
					" * @param a",
					" * @param b",
					" * @param c",
					" * @return",
					" */",
				},
			},
		},
	},
}
