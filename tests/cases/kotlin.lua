return {
	func = {
		---No parametres, no explicit return
		{
			structure = {
				"fun foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ",
					" */",
				},
			},
		},
		---No parametres, nothing returned explicitely
		{
			structure = {
				"fun foo(): Unit {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ",
					" *",
					" * @return", ---BUG: Shouldn't consider `Unit` a return type
					" */",
				},
			},
		},
		---No parametres, return
		{
			structure = {
				"fun foo(): int {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ",
					" *",
					" * @return",
					" */",
				},
			},
		},
		---Parametres and return
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
		---No attributes
		{
			structure = {
				"public class Foo {",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ",
					" */",
				},
			},
		},
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
					" */",
				},
			},
		},
	},
}
