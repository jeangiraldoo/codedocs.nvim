return {
	placement = "above",
	blocks = {
		{
			name = "title",
			item_names = {},
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
			item_names = { "parameters" },
			gap_before = {
				returns = {
					enabled = false,
					text = "//",
				},
			},
			items = { insert_gap_between = { text = "//" } },
		},
		{
			name = "returns",
			item_names = { "returns" },
			items = { insert_gap_between = { text = "//" } },
		},
	},
}
