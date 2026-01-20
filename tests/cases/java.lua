return {
	func = {
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
					" * Attributes:",
					" */",
				},
			},
		},
	},
}
