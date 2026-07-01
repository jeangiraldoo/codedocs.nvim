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
					text = " *",
					enabled = true,
				},
			},
		},
		{
			name = "attributes",
			item_names = { "attributes" },
			gap_before = {
				footer = {
					text = " *",
					enabled = false,
				},
			},
			items = {
				insert_gap_between = {
					text = " *",
				},
			},
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
