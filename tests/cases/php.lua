return {
	func = {
		{
			structure = {
				"<?php",
				"function add(int $a, int $b, int $c): int",
				"{",
				"	return $a;",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ",
					" * ",
					" * @param int $a",
					" * @param int $b",
					" * @param int $c",
					" * @return",
					" */",
				},
			},
		},
	},
}
