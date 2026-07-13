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
					layout = {
						" * @property {%item_type} %item_name ${%snip_idx:description}",
					},
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
