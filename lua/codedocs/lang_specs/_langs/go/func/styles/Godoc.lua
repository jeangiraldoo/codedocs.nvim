return {
	settings = {
		layout = {},
		relative_position = "above",
		insert_at = 1,
		section_order = {
			"parameters",
			"returns",
		},
		indented = false,
	},
	sections = {
		title = {
			layout = {
				"// ${%snippet_tabstop_idx:title}",
			},
			insert_gap_between = {
				enabled = false,
				text = "//",
			},
		},
		parameters = {
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
		returns = {
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
}
