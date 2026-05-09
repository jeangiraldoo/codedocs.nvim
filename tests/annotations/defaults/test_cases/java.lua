return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"public void foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
		-- {
		-- 	structure = {
		-- 		"public int foo() {",
		-- 		"}",
		-- 	},
		-- 	cursor_pos = 1,
		-- 	expected_annotation = {
		-- 		JavaDoc = {
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
				"public int foo(int a, int b) {",
				"	return a + b;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
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
	class = {
		{
			structure = {
				"public class Foo {",
				"	private int name;",
				"	public static int value;",
				"	public int foo(int a, int b) {",
				"		return a + b;",
				"	}",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
	},
}
