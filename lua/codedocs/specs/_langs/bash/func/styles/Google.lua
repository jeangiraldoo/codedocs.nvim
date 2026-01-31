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
			"# ",
		},
		cursor_pos = 1,
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
			include_type = false,
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
			include_type = false,
			template = {
				"#   ",
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
			include_type = true,
			template = {
				"%item_type:",
			},
		},
	},
}
