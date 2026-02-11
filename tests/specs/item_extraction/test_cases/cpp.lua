return {
	func = {
		{
			structure = {
				"void foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				return_type = {},
			},
		},
		{
			structure = {
				"int foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				return_type = {
					{
						name = "",
						type = "int",
					},
				},
			},
		},
		{
			structure = {
				"int add(int a, int b, int c) {",
				"    return a + b",
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
