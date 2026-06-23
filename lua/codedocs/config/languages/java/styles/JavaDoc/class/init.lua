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
					enabled = false,
				},
				footer = {
					text = " *",
					enabled = false,
				},
			},
		},
		{
			name = "attributes",
			layout = { " * Attributes:" },
			gap_before = {
				footer = {
					enabled = false,
					text = " *",
				},
			},
			items = { layout = { "// %item_name" }, insert_gap_between = { text = " *" } },
		},
		{
			name = "footer",
			layout = {
				" */",
			},
		},
	},
}
