return {
	comment = {
		settings = {
			relative_position = "empty_target_or_above",
			indented = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
	func = {
		settings = {
			relative_position = "above",
			indented = false,
		},
		sections = {
			{
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = false,
					text = "//",
				},
			},
			{
				name = "parameters",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "//",
				},
				items = {
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = "//",
					},
				},
			},
			{
				name = "returns",
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = "//",
				},
				items = {
					layout = {},
					insert_gap_between = {
						enabled = false,
						text = "//",
					},
				},
			},
		},
	},
}
