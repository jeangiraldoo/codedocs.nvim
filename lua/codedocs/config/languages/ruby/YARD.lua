return {
	comment = {
		settings = {
			layout = {},
			relative_position = "empty_target_or_above",
			insert_at = 1,
			indent = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	func = {
		settings = {
			layout = {},
			relative_position = "above",
			insert_at = 1,
			indent = false,
		},
		sections = {
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
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "#",
				},
				items = {
					layout = {
						"# @param %item_name [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "#",
					},
				},
			},
			{
				name = "returns",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "#",
				},
				items = {
					layout = {
						"# @return [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
					},
					insert_gap_between = {
						enabled = false,
						text = "#",
					},
				},
			},
		},
	},
}
