return {
	comment = {
		{
			structure = {
				"",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"function foo(a: number, b: number): number {",
				"	return a + b",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ${1:title}",
					" *",
					" * @param a - ${2:description}",
					" * @param b - ${3:description}",
					" * @returns ${4:description}",
					" */",
				},
			},
		},
	},
	class = {
		{
			structure = {
				"class Foo {",
				"	static name: string = 'Codedocs'",
				"	public static value: number;",
				"	",
				"	constructor() {",
				"		this.age = 100",
				"	}",
				"}",
			},
			cursor_pos = 1,
			expected_annotation = {
				TSDoc = {
					"/**",
					" * ${1:title}",
					" */",
				},
			},
		},
	},
}
