return {
	general = {
		layout = {
			'"""',
			'"""',
		},
		direction = false,
		insert_at = 2,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			"",
		},
		cursor_pos = 1,
		gap = {
			enabled = true,
			text = "",
		},
	},
	params = {
		layout = {
			"Args:",
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
				"%item_name (%item_type):",
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
