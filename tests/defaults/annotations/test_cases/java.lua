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
