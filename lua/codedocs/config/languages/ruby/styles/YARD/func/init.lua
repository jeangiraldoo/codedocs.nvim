return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"# ${%snip_idx:title}",
			},
			gap_before = {
				parameters = {
					enabled = true,
					text = "#",
				},
				returns = {
					enabled = true,
					text = "#",
				},
			},
		},
		{
			name = "parameters",
			gap_before = {
				returns = {
					enabled = false,
					text = "#",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						"# @param %item_name [${%snip_idx:type}] ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "#",
					},
					gap_before = {
						enabled = false,
						text = "#",
					},
				},
			},
		},
		{
			name = "returns",
			items = {
				{
					name = "returns",
					layout = {
						"# @return [${%snip_idx:type}] ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "#",
					},
					gap_before = {
						enabled = false,
						text = "#",
					},
				},
			},
		},
	},
}
