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
			layout = {},
			gap_before = {
				footer = {
					enabled = false,
					text = " *",
				},
			},
			items = {
				{
					name = "attributes",
			layout = {},
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = " *",
					},
					gap_before = {
						enabled = false,
						text = " *",
					},
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
