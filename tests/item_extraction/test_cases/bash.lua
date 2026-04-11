return {
	func = {
		generic = {
			{
				structure = {
					"foo() {",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					globals = {},
					parameters = {},
					returns = {},
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
				cursor_pos = { row = 3, col = 1 },
				expected_items = {
					globals = {
						{ name = "GLOBAL_VAR", type = "" },
						{ name = "inner_global", type = "" },
					},
					parameters = {
						{ name = "1", type = "" },
						{ name = "2", type = "" },
					},
					returns = {},
				},
			},
		},
		blocks = {
			returns = {},
			globals = {},
			parameters = {
				generic = {
					{
						structure = {
							"foo() {",
							'  echo "$1"',
							'  echo "$2"',
							"}",
						},
						cursor_pos = { row = 1, col = 1 },
						expected_items = {
							globals = {},
							parameters = {
								{ name = "1", type = "" },
								{ name = "2", type = "" },
							},
							returns = {},
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
						cursor_pos = { row = 3, col = 1 },
						expected_items = {
							globals = {
								{ name = "GLOBAL_VAR", type = "" },
								{ name = "inner_global", type = "" },
							},
							parameters = {},
							returns = {},
						},
					},
				},
			},
		},
	},
}
