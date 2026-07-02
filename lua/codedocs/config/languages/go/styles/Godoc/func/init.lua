return {
	placement = "above",
	blocks = {
		{
			name = "title",
			layout = {
				"// ${%snip_idx:title}",
			},
			gap_before = {
				parameters = {
					text = "//",
					enabled = true,
				},
			},
		},
		{
			name = "parameters",
			layout = {},
			gap_before = {
				returns = {
					enabled = false,
					text = "//",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = "//",
					},
					gap_before = {
						enabled = false,
						text = "//",
					},
				},
			},
		},
		{
			name = "returns",
			items = {
				{
					name = "returns",
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = "//",
					},
					gap_before = {
						enabled = false,
						text = "//",
					},
				},
			},
		},
	},
}
