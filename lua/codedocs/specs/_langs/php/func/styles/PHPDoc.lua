return {
	general = {
		layout = { "/**", " * ", " */" },
		direction = true,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = " *",
		},
		section = {
			gap = false,
			gap_text = " *",
			underline_char = "",
			title_gap = false,
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		section_title = "",
		indent = false,
		include_type = true,
		template = {
			{ "@param", "%item_type", "%item_name" },
		},
	},
	return_type = {
		section_title = "",
		indent = false,
		include_type = false,
		template = {
			"@return",
		},
	},
}
