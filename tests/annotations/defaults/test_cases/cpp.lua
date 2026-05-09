return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"void foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
		-- {
		-- 	structure = {
		-- 		"int foo() {",
		-- 		"}",
		-- 	},
		-- 	cursor_pos = 1,
		-- 	expected_annotation = {
		-- 		Doxygen = {
		-- 			"/**",
		-- 			" * ${1:title}",
		--BUG: no gap is present when there's only a return with no params
		-- 			" *",
		-- 			" * @return ${4:description}",
		-- 			" */",
		-- 		},
		-- 	},
		-- },
		{
			structure = {
				"int foo(int a, int b) {",
				"	return a + b;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				Doxygen = {
					"/**",
					" * ${1:title}",
					" *",
					" * @param a ${2:description}",
					" * @param b ${3:description}",
					" * @return ${4:description}",
					" */",
				},
			},
		},
	},
}
