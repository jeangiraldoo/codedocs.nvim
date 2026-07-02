return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"/**",
				" * ${%snip_idx:description}",
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
					enabled = false,
					text = " *",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						" * @param {${%snip_idx:type}} %item_name ${%snip_idx:description}",
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
						" * @returns {${%snip_idx:type}} ${%snip_idx:description}",
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
