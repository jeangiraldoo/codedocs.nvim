return {
	func = {
		{
			structure = {
				"local function foo(a, b, c)",
				"	return a",
				"end",
			},
			cursor_pos = 1,
			expected_annotation = {
				LDoc = {
					"--- ",
					"-- @param a",
					"-- @param b",
					"-- @param c",
					"-- @return",
				},
			},
		},
	},
}
