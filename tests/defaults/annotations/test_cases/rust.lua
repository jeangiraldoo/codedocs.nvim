return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"fn foo(a: i32, b: i32) -> i32 {",
				"	a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				RustDoc = {
					"/// ${1:title}",
					"///",
					"/// # Arguments",
					"///",
					"/// * `a` - ${2:description}",
					"/// * `b` - ${3:description}",
					"///",
					"/// # Returns",
					"///",
					"/// ${4:description}",
				},
			},
		},
	},
}
