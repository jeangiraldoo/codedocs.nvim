return {
	func = {
		---No parametres, no return
		{
			structure = {
				"public void foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ",
					" *", ---BUG: Seems like the title gap is being applied even if theres no sections
					" */",
				},
			},
		},
		---No parametres, return
		{
			structure = {
				"public int foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ",
					" *", ---BUG: Seems like the title gap is being applied even if theres no sections
					" */",
				},
			},
		},
		---Parametres and return
		{
			structure = {
				"public int foo(int a, int b, int c) {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ",
					" *",
					" * @param a",
					" * @param b",
					" * @param c",
					" * @return",
					" */",
				},
			},
		},
	},
	class = {
		---No attributes
		{
			structure = {
				"public class Foo {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ",
					" *",
					" */",
				},
			},
		},
		{
			structure = {
				"public class Foo {",
				'	public String a = "";',
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JavaDoc = {
					"/**",
					" * ",
					" *",
					" */",
				},
			},
		},
	},
}
