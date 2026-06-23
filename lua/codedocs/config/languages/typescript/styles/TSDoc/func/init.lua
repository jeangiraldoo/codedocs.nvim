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
			gap_before = {
				returns = {
					text = " *",
					enabled = false,
				},
			},
			items = {
				layout = {
					" * @param %item_name - ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = " *",
				},
			},
		},
		{
			name = "returns",
			gap_before = {
				footer = {
					text = " *",
					enabled = false,
				},
			},
			items = {
				layout = {
					" * @returns ${%snip_idx:description}",
				},
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
			insert_gap_between = {
				text = " *",
			},
		},
	},
}
