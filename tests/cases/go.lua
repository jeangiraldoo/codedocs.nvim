return {
	func = {
		{
			structure = {
				"func foo(a int, b int, c int) int {",
				"    return a",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = {
					"// ",
					"//",
					"// Parameters:",
					"// - a:",
					"// - b:",
					"// - c:",
					"//",
					"// Returns:",
					"// ",
				},
			},
		},
	},
}
