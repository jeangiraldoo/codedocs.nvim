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
			gap = true,
			gap_text = "///",
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {
			" # Arguments",
			"",
		},
		indent = false,
		template = {
			" * `%item_name`",
		},
	},
	return_type = {
		layout = {
			" # Returns",
			"",
		},
		indent = false,
		template = {
			"",
		},
	},
}
