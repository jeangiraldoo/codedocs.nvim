return {
	func = {
		{
			structure = {
				"fn foo() {",
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
				"fn foo() -> String {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {},
				return_type = {
					{
						name = "",
						type = "String",
					},
				},
			},
		},
		{
			structure = {
				"fn foo(a: String, b: String, c: String) {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "String",
					},
					{
						name = "b",
						type = "String",
					},
					{
						name = "c",
						type = "String",
					},
				},
				return_type = {},
			},
		},
		{
			structure = {
				"fn foo(a: String, b: String, c: String) -> String {",
				"    return a",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "String",
					},
					{
						name = "b",
						type = "String",
					},
					{
						name = "c",
						type = "String",
					},
				},
				return_type = {
					{
						name = "",
						type = "String",
					},
				},
			},
		},
	},
}
