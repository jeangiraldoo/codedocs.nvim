return {
	comment = {
		placement = "current",
		blocks = {
			{
				name = "title",
				layout = {
					"// ${%snip_idx:description}",
				},
			},
		},
	},
	func = {
		placement = "above",
		blocks = {
			{
				name = "title",
				layout = {
					"/// ${%snip_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "///",
				},
			},
			{
				name = "parameters",
				layout = { "/// # Arguments", "///" },
				insert_gap_between = { enabled = true, text = "///" },
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
				layout = { "/// # Returns", "///" },
				insert_gap_between = {
					enabled = true,
					text = "///",
				},
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
	},
}
