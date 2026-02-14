return {
	settings = {
		layout = {
			"#######################################",
			"#######################################",
		},
		relative_position = "above",
		insert_at = 2,
		section_order = {
			"globals",
			"parameters",
			"returns",
		},
		item_extraction = {},
	},
	sections = {
		title = {
			layout = {
				"# ${%snippet_tabstop_idx:title}",
			},
			insert_gap_between = {
				enabled = false,
				text = "",
			},
		},
		globals = {
			layout = {
				"# Globals:",
			},
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			items = {
				layout = {
					"#   %item_name",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = false,
			},
		},
		parameters = {
			layout = {
				"# Arguments:",
			},
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			items = {
				layout = {
					"#   ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = false,
			},
		},
		returns = {
			layout = {
				"Returns:",
			},
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			items = {
				layout = {
					"%item_type:",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = true,
			},
		},
	},
}
