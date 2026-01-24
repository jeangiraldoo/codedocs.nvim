return {
	general = {
		layout = { '"""', "", '"""' },
		direction = false,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = "",
		},
		section = {
			gap = false,
			gap_text = "",
			underline_char = "",
			title_gap = false,
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		section_title = "Args:",
		indent = true,
		include_type = true,
		template = {
			"%item_name (%item_type):",
		},
	},
	return_type = {
		section_title = "Returns:",
		indent = true,
		include_type = true,
		template = {
			"%item_type:",
		},
	},
}
