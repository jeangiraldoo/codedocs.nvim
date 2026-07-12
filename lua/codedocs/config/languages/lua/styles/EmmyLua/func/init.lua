return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"---${%snip_idx:title}",
			},
			gap_before = {
				parameters = {
					enabled = false,
					text = "---",
				},
				returns = {
					enabled = false,
					text = "---",
				},
			},
		},
		{
			name = "parameters",
			layout = {},
			gap_before = {
				returns = {
					enabled = false,
					text = "---",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						"---@param %item_name ${%snip_idx:type} ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "---",
					},
					gap_before = {
						returns = {
							enabled = true,
							text = "---",
						},
					},
				},
			},
		},
		{
			name = "returns",
			layout = {},
			items = {
				{
					name = "returns",
					layout = {
						"---@return ${%snip_idx:type} ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "---",
					},
					gap_before = {},
				},
			},
		},
	},
}
