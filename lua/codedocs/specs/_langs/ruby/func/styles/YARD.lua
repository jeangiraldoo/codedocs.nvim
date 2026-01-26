return {
	general = {
		layout = { "# ", "# " },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = true,
			gap_text = "#",
		},
		section_order = {
			"params",
			"return_type",
		},
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = "#",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "#",
			},
			indent = false,
			include_type = false,
			template = {
				"# @param %item_name [%item_type]",
			},
		},
	},
	return_type = {
		layout = {},
		gap = {
			enabled = false,
			text = "#",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "#",
			},
			indent = false,
			include_type = false,
			template = {
				"# @return [%item_type]",
			},
		},
	},
}
