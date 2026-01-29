return {
	func = {
		{
			structure = {
				"local function foo()",
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
				"local function foo()",
				"	return a",
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
				"local function foo(a, b, c)",
				"	return a",
				"end",
			},
			cursor_pos = 1,
			expected_items = {
				params = {
					{
						name = "a",
					},
					{
						name = "b",
					},
					{
						name = "c",
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
