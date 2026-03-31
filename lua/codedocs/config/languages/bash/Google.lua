return {
	comment = {
		settings = {
			layout = {},
			relative_position = "empty_target_or_above",
			insert_at = 1,
			section_order = {},
			indented = false,
		},
		sections = {
			title = {
				layout = {
					"# ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
			},
		},
	},
	func = {
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
			indented = false,
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
				},
			},
		},
	},
}
