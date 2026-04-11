return {
	func = {
		generic = {
			{
				structure = {
					"local function foo()",
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
					"local function foo(a, b, c)",
					"	return a",
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
							"local function foo()",
							"	return a",
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
							"local function foo(a, b, c)",
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
