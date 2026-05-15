return {
	comment = {
		relative_position = "empty_target_or_above",
		blocks = {
			{
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
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
					"# ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = true,
					text = "#",
				},
			},
			{
				name = "parameters",
				insert_gap_between = { text = "#" },
				items = {
					layout = {
						"# @param %item_name [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						text = "#",
					},
				},
			},
			{
				name = "returns",
				insert_gap_between = { text = "#" },
				items = {
					layout = {
						"# @return [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						text = "#",
					},
				},
			},
		},
	},
}
