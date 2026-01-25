return {
	general = {
		layout = { "///", "///" },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = true,
			gap_text = "///",
		},
		section = {
			order = { "params", "return_type" },
		},
		item_gap = false,
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
			indent = false,
			include_type = false,
			template = {
				"",
			},
		},
	},
}
