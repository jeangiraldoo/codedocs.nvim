return {
	func = {
		{
			structure = {
				"def foo()",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				returns = {},
			},
		},
		{
			structure = {
				"def foo()",
				"    return 2",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				returns = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
		{
			structure = {
				"def foo(a, b, c)",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "",
					},
					{
						name = "b",
						type = "",
					},
					{
						name = "c",
						type = "",
					},
				},
				returns = {},
			},
		},
		{
			structure = {
				"def foo(a, b, c)",
				"    return a",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "",
					},
					{
						name = "b",
						type = "",
					},
					{
						name = "c",
						type = "",
					},
				},
				returns = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
	},
}
