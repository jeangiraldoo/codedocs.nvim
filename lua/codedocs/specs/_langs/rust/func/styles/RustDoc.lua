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
			underline_char = "",
			title_gap = true,
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		section_title = " # Arguments",
		indent = false,
		template = {
			" * `%item_name`",
		},
	},
	return_type = {
		section_title = " # Returns",
		indent = false,
		template = {
			"",
		},
	},
}
