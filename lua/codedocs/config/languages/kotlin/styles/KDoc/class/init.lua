return {
	placement = "above",
	blocks = {
		{
			name = "header",
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
			layout = {
				" */",
			},
		},
	},
}
