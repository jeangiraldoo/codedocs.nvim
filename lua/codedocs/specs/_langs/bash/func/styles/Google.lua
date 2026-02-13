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
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = false,
				template = {
					"#   %item_name",
				},
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
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = false,
				template = {
					"#   ${%snippet_tabstop_idx:description}",
				},
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
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = true,
				template = {
					"%item_type:",
				},
			},
		},
	},
}
