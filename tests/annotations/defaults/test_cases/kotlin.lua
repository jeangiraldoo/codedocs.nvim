return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"fun foo(a: int , b: int): int {",
				"	return a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
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
				"class Foo {",
				"	private var name: Int = 0",
				"",
				"	companion object {",
				"		var value: Int = 0",
				"	}",
				"	fun foo(a: Int, b: Int): Int {",
				"		return a + b",
				"	}",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				KDoc = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
	},
}
