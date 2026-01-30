return {
	func = {
		{
			structure = {
				"func foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"func foo() int {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {
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
				params = {
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
				return_type = {
					{
						name = "",
						type = "int",
					},
				},
			},
		},
	},
}
