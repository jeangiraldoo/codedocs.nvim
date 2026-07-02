return {
	placement = "above",
	blocks = {
		{
			name = "header",
			layout = {
				"/// ${%snip_idx:title}",
			},
			gap_before = {
				parameters = {
					enabled = true,
					text = "///",
				},
				returns = {
					enabled = true,
					text = "///",
				},
			},
		},
		{
			name = "parameters",
			layout = { "/// # Arguments", "///" },
			gap_before = {
				returns = {
					enabled = true,
					text = "///",
				},
			},
			items = {
				{
					name = "parameters",
					layout = {
						"/// * `%item_name` - ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "///",
					},
					gap_before = {
						text = "///",
						enabled = false,
					},
				},
			},
		},
		{
			name = "returns",
			layout = { "/// # Returns", "///" },
			items = {
				{
					name = "returns",
					layout = {
						"/// ${%snip_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "///",
					},
					gap_before = {
						enabled = false,
						text = "///",
					},
				},
			},
		},
	},
}
