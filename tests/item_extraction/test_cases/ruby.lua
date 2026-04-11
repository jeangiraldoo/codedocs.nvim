return {
	func = {
		generic = {
			{
				structure = {
					"def foo()",
					"end",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
			{
				structure = {
					"def foo(a, b, c)",
					"    return a",
					"end",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {
						{ name = "a", type = "" },
						{ name = "b", type = "" },
						{ name = "c", type = "" },
					},
					returns = {
						{ name = "", type = "" },
					},
				},
			},
		},
		blocks = {
			returns = {
				generic = {
					{
						structure = {
							"def foo()",
							"    return 2",
							"end",
						},
						cursor_pos = { row = 1, col = 1 },
						expected_items = {
							parameters = {},
							returns = {
								{ name = "", type = "" },
							},
						},
					},
				},
			},
			parameters = {
				generic = {
					{
						structure = {
							"def foo(a, b, c)",
							"end",
						},
						cursor_pos = { row = 1, col = 1 },
						expected_items = {
							parameters = {
								{ name = "a", type = "" },
								{ name = "b", type = "" },
								{ name = "c", type = "" },
							},
							returns = {},
						},
					},
				},
			},
		},
	},
}
