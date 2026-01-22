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
				Godoc = { ---BUG: No section should be added
					"// ",
					"//",
					"// Parameters:",
					"//",
					"// Returns:",
				},
			},
		},
		---No parametres, return
		{
			structure = {
				"func foo() int {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = { ---BUG: Only the return section should be present
					"// ",
					"//",
					"// Parameters:",
					"//",
					"// Returns:",
					"// ",
				},
			},
		},
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
