return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"function foo(a, b) {",
				"	return a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ${1:description}",
					" *",
					" * @param {${2:type}} a ${3:description}",
					" * @param {${4:type}} b ${5:description}",
					" * @returns {${6:type}} ${7:description}",
					" */",
				},
			},
		},
	},
	class = {
		{
			structure = {
				"class Foo {",
				"	static name = 'Codedocs'",
				"	public static int value;",
				"	",
				"	constructor() {",
				"		this.age = 100",
				"	}",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				JSDoc = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
	},
}
