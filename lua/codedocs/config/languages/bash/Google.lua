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
			relative_position = "above",
			indented = false,
		},
		sections = {
			{
				name = "header",
				layout = {
					"#######################################",
					"# ${%snippet_tabstop_idx:title}",
				},
				insert_gap_between = {
					enabled = false,
					text = "",
				},
			},
			{
				name = "globals",
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
			{
				name = "parameters",
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
			{
				name = "returns",
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
			{
				name = "footer",
				layout = {
					"#######################################",
				},
				ignore_prev_gap = true,
			},
		},
	},
}
