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
				parameters = {
					enabled = true,
					text = " *",
				},
				returns = {
					enabled = true,
					text = " *",
				},
			},
		},
		{
			name = "parameters",
			layout = {},
			gap_before = {
				returns = {
					enabled = false,
					text = " *",
				},
			},
			items = {
				{
					name = "parameters",
					layout = { " * @param %item_name ${%snip_idx:description}" },
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
			name = "returns",
			layout = {},
			gap_before = {
				footer = {
					enabled = false,
					text = " *",
				},
			},
			items = {
				{
					name = "returns",
					layout = {
						" * @return ${%snip_idx:description}",
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
			gap_before = {},
		},
	},
}
