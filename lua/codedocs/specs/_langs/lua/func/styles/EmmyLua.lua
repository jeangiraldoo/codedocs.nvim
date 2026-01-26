return {
	general = {
		layout = {},
		direction = true,
		insert_at = 1,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			"---",
		},
		cursor_pos = 1,
		gap = {
			enabled = false,
			text = "--",
		},
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = "---",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "---",
			},
			indent = false,
			include_type = false,
			template = {
				"---@param %item_name",
			},
		},
	},
	return_type = {
		layout = {},
		gap = {
			enabled = false,
			text = "---",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "---",
			},
			indent = false,
			include_type = false,
			template = {
				"---@return",
			},
		},
	},
}
