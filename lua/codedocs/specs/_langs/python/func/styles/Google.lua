return {
	general = {
		layout = { '"""', "", '"""' },
		direction = false,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = "",
		},
		section_order = {
			"params",
			"return_type",
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
			insert_gap_between = false,
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
			insert_gap_between = false,
			indent = true,
			include_type = true,
			template = {
				"%item_type:",
			},
		},
	},
}
