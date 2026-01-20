return {
	func = {
		{
			structure = {
				"fun foo(a: Int, b: Int, c: Int): Int {",
				"    return a;",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
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
				'	var a: String = "";',
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ",
					" *",
					" */",
				},
			},
		},
	},
}
