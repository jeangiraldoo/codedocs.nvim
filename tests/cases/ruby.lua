return {
	func = {
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
					"# ",
					"# @param a []",
					"# @param b []",
					"# @param c []",
					"# @return []",
				},
			},
		},
	},
}
