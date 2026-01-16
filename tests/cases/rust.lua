return {
	func = {
		{
			structure = {
				"fn foo(a: String, b: String, c: String) -> String {",
				"    return a",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = {
					"///",
					"///",
					"/// # Arguments",
					"///",
					"/// * `a`",
					"/// * `b`",
					"/// * `c`",
					"///",
					"/// # Returns",
					"///",
					"///",
				},
			},
		},
	},
}
