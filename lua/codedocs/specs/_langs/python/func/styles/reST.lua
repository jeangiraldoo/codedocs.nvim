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
		layout = {},
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
			include_type = true,
			template = {
				":param %item_name:",
				":type %item_name:",
			},
		},
	},
	return_type = {
		layout = {},
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
			include_type = true,
			template = {
				":return:",
				{ ":rtype:", "%item_type" },
			},
		},
	},
}
