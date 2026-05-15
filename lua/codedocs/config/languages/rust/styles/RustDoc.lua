return {
	comment = {
		relative_position = "empty_target_or_above",
		blocks = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	func = {
		relative_position = "above",
		blocks = {
			{
				name = "title",
				layout = {
					"/// ${%snippet_tabstop_idx:title}",
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
						"/// * `%item_name` - ${%snippet_tabstop_idx:description}",
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
						"/// ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						text = "///",
					},
				},
			},
		},
	},
}
