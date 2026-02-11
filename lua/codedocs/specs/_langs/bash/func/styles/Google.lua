return {
	general = {
		layout = {
			"#######################################",
			"#######################################",
		},
		direction = true,
		insert_at = 2,
		section_order = {
			"globals",
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			"# ${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = false,
			text = "",
		},
	},
	globals = {
		layout = {
			"# Globals:",
		},
		gap = {
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
	params = {
		layout = {
			"# Arguments:",
		},
		gap = {
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
	return_type = {
		layout = {
			"Returns:",
		},
		gap = {
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
}
