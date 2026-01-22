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
				RustDoc = {
					"///",
					"///", ---BUG: Leftover line, likely item gap
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
				RustDoc = {
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
				RustDoc = {
					"///",
					"///",
					"/// # Arguments",
					"///",
					"/// * `a`",
					"/// * `b`",
					"/// * `c`",
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
