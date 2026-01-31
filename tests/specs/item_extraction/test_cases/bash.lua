return {
	func = {
		{
			structure = {
				"foo() {",
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				globals = {},
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"foo() {",
				'  echo "$1"',
				'  echo "$2"',
				"}",
			},
			cursor_pos = 1,
			expected_items = {
				globals = {},
				params = {
					{
						name = "1",
					},
					{
						name = "2",
					},
				},
				return_type = {},
			},
		},
		{
			structure = {
				"GLOBAL_VAR=1",
				'unused_global_var="hi"',
				"foo() {",
				"  inner_global=2",
				"  local inner_local=3",
				'  echo "${GLOBAL_VAR}"',
				'  echo "${inner_global}"',
				"}",
			},
			cursor_pos = 3,
			expected_items = {
				globals = {
					{
						name = "GLOBAL_VAR",
					},
					{
						name = "inner_global",
					},
				},
				params = {},
				return_type = {},
			},
		},
		{
			structure = {
				"GLOBAL_VAR=1",
				"foo() {",
				"  inner_global=2",
				"  local inner_local=3",
				'  echo "${GLOBAL_VAR}"',
				'  echo "${inner_global}"',
				'  echo "$1"',
				'  echo "$2"',
				"}",
			},
			cursor_pos = 3,
			expected_items = {
				globals = {
					{
						name = "GLOBAL_VAR",
					},
					{
						name = "inner_global",
					},
				},
				params = {
					{
						name = "1",
					},
					{
						name = "2",
					},
				},
				return_type = {},
			},
		},
	},
}
