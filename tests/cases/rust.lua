return {
	func = {
		---No parametres, no return
		{
			structure = {
				"fn foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = { ---BUG: No section should be present
					"///",
					"///",
					"/// # Arguments",
					"///",
					"///",
					"/// # Returns",
					"///",
				},
			},
		},
		---No parametres, return
		{
			structure = {
				"fn foo() --> String {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = { ---BUG: only the return section should be present
					"///",
					"///",
					"/// # Arguments",
					"///",
					"///",
					"/// # Returns",
					"///",
					"///",
				},
			},
		},
		---Only parametres
		{
			structure = {
				"fn foo(a: String, b: String, c: String) {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = { ---BUG: only the Arguments section should be present
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
				},
			},
		},
		---Parametres and return
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
