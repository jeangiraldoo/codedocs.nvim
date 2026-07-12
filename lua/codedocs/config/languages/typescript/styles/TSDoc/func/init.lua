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
					text = " *",
					enabled = true,
				},
				returns = {
					text = " *",
					enabled = true,
				},
			},
		},
		{
			name = "parameters",
			layout = {},
			gap_before = {
				returns = {
					text = " *",
					enabled = false,
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						" * @param %item_name - ${%snip_idx:description}",
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
			name = "returns",
			layout = {},
			gap_before = {
				footer = {
					text = " *",
					enabled = false,
				},
			},
			items = {
				{
					name = "returns",
					layout = {
						" * @returns ${%snip_idx:description}",
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
