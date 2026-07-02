return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"#######################################",
				"# ${%snip_idx:title}",
			},
		},
		{
			name = "globals",
			layout = { "# Globals:" },
			items = {
				{
					name = "globals",
					layout = { "#   %item_name" },
					insert_gap_between = {
						enabled = false,
						text = " #",
					},
					gap_before = {},
				},
			},
		},
		{
			name = "parameters",
			layout = { "# Arguments:" },
			items = {
				{
					name = "parameters",
					layout = { "#   ${%snip_idx:description}" },
					insert_gap_between = {
						enabled = false,
						text = " #",
					},
					gap_before = {},
				},
			},
		},
		{
			name = "returns",
			layout = { "Returns:" },
			items = {
				{
					name = "returns",
					layout = { "%item_type:" },
					insert_gap_between = {
						enabled = false,
						text = " #",
					},
					gap_before = {},
				},
			},
		},
		{
			name = "footer",
			layout = {
				"#######################################",
			},
		},
	},
}
