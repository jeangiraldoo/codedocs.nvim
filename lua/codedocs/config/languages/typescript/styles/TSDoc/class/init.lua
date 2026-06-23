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
					text = " *",
					enabled = true,
				},
			},
		},
		{
			name = "attributes",
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
			layout = {
				" */",
			},
		},
	},
}
