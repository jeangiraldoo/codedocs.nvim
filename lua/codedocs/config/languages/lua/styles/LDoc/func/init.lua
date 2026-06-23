return {
	placement = "above",
	blocks = {
		{
			name = "title",
			layout = {
				"--- ${%snip_idx:title}",
			},
			gap_before = {
				parameters = {
					enabled = false,
					text = "--",
				},
				returns = {
					enabled = false,
					text = "--",
				},
			},
		},
		{
			name = "parameters",
			gap_before = {
				returns = {
					enabled = false,
					text = "--",
				},
			},
			items = {
				layout = {
					"-- @param %item_name ${%snip_idx:type} ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "--",
				},
			},
		},
		{
			name = "returns",
			items = {
				layout = {
					"-- @return ${%snip_idx:type} ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "--",
				},
			},
		},
	},
}
