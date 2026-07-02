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
						" * @param %item_name ${%snip_idx:description}",
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
		},
	},
}
