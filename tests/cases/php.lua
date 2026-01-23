return {
	func = {
		---No parametres, no return statement or annotation
		{
			structure = {
				"<?php",
				"function add()",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ",
					" */",
				},
			},
		},
		---No parametres, return type annotation
		{
			structure = {
				"<?php",
				"function add(): int",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ",
					" */",
				},
			},
		},
		---No parametres, return statement
		{
			structure = {
				"<?php",
				"function add()",
				"{",
				"	return 2",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ",
					" *",
					" * @return",
					" */",
				},
			},
		},
		---Only unannotated parametres
		{
			structure = {
				"<?php",
				"function add(int $a, int $b, int $c)",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = { ---BUG: Parametres aren't detected if they have no type annotation
					"/**",
					" * ",
					" *",
					" * @param int $a",
					" * @param int $b",
					" * @param int $c",
					" */",
				},
			},
		},
		---Only annotated parametres
		{
			structure = {
				"<?php",
				"function add(int $a, int $b, int $c)",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_annotation = {
				PHPDoc = {
					"/**",
					" * ",
					" *",
					" * @param int $a",
					" * @param int $b",
					" * @param int $c",
					" */",
				},
			},
		},
		--- Annotated parametres and return annotation
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
					" *",
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
