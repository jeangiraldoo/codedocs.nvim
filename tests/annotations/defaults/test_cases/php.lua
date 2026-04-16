return {
	comment = {
		{
			structure = {
				"<?php",
				"",
			},
			cursor_pos = 2,
			expected_annotation = {
				PHPDoc = {
					"// ${1:description}",
				},
			},
		},
	},
	phptag = {
		{
			structure = { "" },
			cursor_pos = 1,
			expected_annotation = {
				PHPDoc = {
					"<?php",
					"${1:code}",
				},
			},
		},
	},
	func = {
		{
			structure = {
				"<?php",
				"function foo($a, $b) {",
				"	return $a + $b;",
				"}",
			},
			cursor_pos = 2,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ${1:title}",
					" *",
					" * @param ${2:} \\$a ${3:description}",
					" * @param ${4:} \\$b ${5:description}",
					" * @return ${6:} ${7:description}",
					" */",
				},
			},
		},
		{
			structure = {
				"<?php",
				"function foo(int $a, int $b): int {",
				"	return $a + $b;",
				"}",
			},
			cursor_pos = 2,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ${1:title}",
					" *",
					" * @param ${2:int} \\$a ${3:description}",
					" * @param ${4:int} \\$b ${5:description}",
					" * @return ${6:int} ${7:description}",
					" */",
				},
			},
		},
	},
}
