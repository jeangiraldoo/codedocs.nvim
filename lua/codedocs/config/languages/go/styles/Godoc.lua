return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
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
		indented = false,
		blocks = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					text = "//",
				},
			},
			{
				name = "parameters",
				insert_gap_between = { text = "//" },
				items = { insert_gap_between = { text = "//" } },
			},
			{
				name = "returns",
				insert_gap_between = { text = "//" },
				items = { insert_gap_between = { text = "//" } },
			},
		},
	},
}
