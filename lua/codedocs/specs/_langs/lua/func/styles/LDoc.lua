return {
	general = {
		layout = { "--- ", "-- " },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = false,
			gap_text = "--",
		},
		section = {
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = "--",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				"@param %item_name",
			},
		},
	},
	return_type = {
		layout = {},
		gap = {
			enabled = false,
			text = "--",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				"@return",
			},
		},
	},
}
