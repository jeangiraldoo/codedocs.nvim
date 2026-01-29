return {
	func = {
		---No Parametres, no return
		{
			structure = {
				"func foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = {
					"// ",
				},
			},
		},
		---Only return type
		{
			structure = {
				"func foo() int {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = {
					"// ",
					"//",
					"// Returns:",
					"// ",
				},
			},
		},
		---Parametres and return type
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
