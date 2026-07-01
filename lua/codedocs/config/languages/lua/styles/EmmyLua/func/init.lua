return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
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
			item_names = { "parameters" },
			gap_before = {
				returns = {
					enabled = false,
					text = "---",
				},
			},
			items = {
				layout = {
					"---@param %item_name ${%snip_idx:type} ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "---",
				},
			},
		},
		{
			name = "returns",
			item_names = { "returns" },
			items = {
				layout = {
					"---@return ${%snip_idx:type} ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "---",
				},
			},
		},
	},
}
