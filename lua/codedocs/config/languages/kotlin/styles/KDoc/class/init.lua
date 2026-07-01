return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
			layout = {
				"/**",
				" * ${%snip_idx:title}",
			},
			gap_before = {
				attributes = {
					enabled = true,
					text = " *",
				},
			},
		},
		{
			name = "attributes",
			item_names = { "attributes" },
			gap_before = {
				footer = {
					enabled = false,
					text = " *",
				},
			},
			items = { insert_gap_between = { text = " *" } },
		},
		{
			name = "footer",
			item_names = {},
			layout = {
				" */",
			},
		},
	},
}
