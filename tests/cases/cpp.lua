return {
	func = {
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
					" * ",
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
