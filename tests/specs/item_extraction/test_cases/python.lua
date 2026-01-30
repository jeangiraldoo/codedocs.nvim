return {
	func = {
		{
			structure = {
				"def foo():",
				"	pass",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"def foo() -> bool:",
				"	pass",
			},
			cursor_pos = 1,
			expected_items = {
				params = {},
				return_type = {
					{
						name = "",
						type = "bool",
					},
				},
			},
		},
		{
			structure = {
				"def foo(a, b, c):",
				"	return a",
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
	class = {
		{
			structure = {
				"class Foo:",
				'	a = ""',
			},
			cursor_pos = 1,
			expected_items = {
				attrs = {
					{
						name = "a",
						type = "",
					},
				},
			},
		},
	},
}
