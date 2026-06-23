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
			layout = {
				" */",
			},
		},
	},
}
