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
					" * @return ${6:} ${7:description}", -- FIX: return type is not being detected
					" */",
				},
			},
		},
	},
}
