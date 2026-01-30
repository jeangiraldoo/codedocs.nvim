return {
	func = {
		{
			structure = {
				"def foo()",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {},
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
				params = {},
				return_type = {
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
				params = {
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
				return_type = {},
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
				params = {
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
				return_type = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
	},
}
