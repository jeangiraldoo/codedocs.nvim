return {
	func = {
		generic = {
			{
				structure = {
					"function foo() {",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					parameters = {},
					returns = {},
				},
			},
		},
		blocks = {
			returns = {
				generic = {
					{
						structure = {
							"function foo() {",
							"    return 2;",
							"}",
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
							"function foo(a, b, c) {",
							"    return a;",
							"}",
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
			},
		},
	},
	class = {
		generic = {
			{
				structure = {
					"class Foo {",
					"	a = '';",
					"}",
				},
				cursor_pos = { row = 1, col = 1 },
				expected_items = {
					attributes = {},
				},
			},
		},
	},
}
