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
					text = " *",
					enabled = false,
				},
			},
			items = {
				layout = {
					" * @param ${%snip_idx:%item_type} \\$%item_name ${%snip_idx:description}",
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
					" * @return ${%snip_idx:%item_type} ${%snip_idx:description}",
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
