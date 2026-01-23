return {
	func = {
		---No parametres, no return
		{
			structure = {
				"def foo()",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				YARD = {
					"# ",
				},
			},
		},
		---No parametres, return statement
		{
			structure = {
				"def foo()",
				"    return 2",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				YARD = {
					"# ",
					"#",
					"# @return []",
				},
			},
		},
		---Only parametres
		{
			structure = {
				"def foo(a, b, c)",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				YARD = {
					"# ",
					"#",
					"# @param a []",
					"# @param b []",
					"# @param c []",
				},
			},
		},
		---Parametres and return
		{
			structure = {
				"def foo(a, b, c)",
				"    return a",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				YARD = {
					"# ",
					"#",
					"# @param a []",
					"# @param b []",
					"# @param c []",
					"# @return []",
				},
			},
		},
	},
}
