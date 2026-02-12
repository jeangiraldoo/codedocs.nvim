return {
	func = {
		{
			structure = {
				"func foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				returns = {},
			},
		},
		{
			structure = {
				"func foo() int {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				returns = {
					{
						name = "",
						type = "int",
					},
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
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "int",
					},
					{
						name = "b",
						type = "int",
					},
					{
						name = "c",
						type = "int",
					},
				},
				returns = {
					{
						name = "",
						type = "int",
					},
				},
			},
		},
	},
}
