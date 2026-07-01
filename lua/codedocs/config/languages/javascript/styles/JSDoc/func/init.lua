return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
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
			item_names = { "parameters" },
			gap_before = {
				returns = {
					enabled = false,
					text = " *",
				},
			},
			items = {
				layout = {
					" * @param {${%snip_idx:type}} %item_name ${%snip_idx:description}",
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
					enabled = false,
					text = " *",
				},
			},
			items = {
				layout = {
					" * @returns {${%snip_idx:type}} ${%snip_idx:description}",
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
		},
	},
}
