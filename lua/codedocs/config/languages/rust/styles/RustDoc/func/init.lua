return {
	placement = "above",
	blocks = {
		{
			name = "header",
			item_names = {},
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
			item_names = { "parameters" },
			layout = { "/// # Arguments", "///" },
			gap_before = {
				returns = {
					enabled = true,
					text = "///",
				},
			},
			items = {
				layout = {
					"/// * `%item_name` - ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "///",
				},
			},
		},
		{
			name = "returns",
			item_names = { "returns" },
			layout = { "/// # Returns", "///" },
			items = {
				layout = {
					"/// ${%snip_idx:description}",
				},
				insert_gap_between = {
					text = "///",
				},
			},
		},
	},
}
