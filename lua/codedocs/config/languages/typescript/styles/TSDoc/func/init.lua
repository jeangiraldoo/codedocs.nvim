return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
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
			item_names = { "parameters" },
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
			item_names = { "returns" },
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
			item_names = {},
			layout = {
				" */",
			},
			insert_gap_between = {
				text = " *",
			},
		},
	},
}
