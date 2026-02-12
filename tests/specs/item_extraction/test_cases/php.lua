return {
	func = {
		{
			structure = {
				"<?php",
				"function add()",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_items = {
				parameters = {},
				returns = {},
			},
		},
		{
			structure = {
				"<?php",
				"function add(): int",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_items = {
				parameters = {},
				returns = {},
			},
		},
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
			expected_items = {
				parameters = {},
				returns = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
		{
			structure = {
				"<?php",
				"function add(int $a, int $b, int $c)",
				"{",
				"}",
				"?>",
			},
			cursor_pos = 3,
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "int",
					},
					{
						name = "b",
						type = "int",
					},
					{
						name = "c",
						type = "int",
					},
				},
				returns = {},
			},
		},
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
			expected_items = {
				parameters = {
					{
						name = "a",
						type = "int",
					},
					{
						name = "b",
						type = "int",
					},
					{
						name = "c",
						type = "int",
					},
				},
				returns = {
					{
						name = "",
						type = "",
					},
				},
			},
		},
	},
}
