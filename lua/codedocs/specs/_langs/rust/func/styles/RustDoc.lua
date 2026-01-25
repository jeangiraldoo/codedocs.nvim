return {
	general = {
		layout = { "///", "///" },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = true,
			gap_text = "///",
		},
		section_order = {
			"params",
			"return_type",
		},
	},
	params = {
		layout = {
			" # Arguments",
			"",
		},
		gap = {
			enabled = true,
			text = "///",
		},
		items = {
			insert_gap_between = false,
			include_type = false,
			indent = false,
			template = {
				" * `%item_name`",
			},
		},
	},
	return_type = {
		layout = {
			" # Returns",
			"",
		},
		gap = {
			enabled = true,
			text = "///",
		},
		items = {
			insert_gap_between = false,
			indent = false,
			include_type = false,
			template = {
				"",
			},
		},
	},
}
