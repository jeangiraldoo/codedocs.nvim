return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"func foo(a int, b int) int {",
				"	return a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Godoc = {
					"// ${1:title}",
				},
			},
		},
	},
}
