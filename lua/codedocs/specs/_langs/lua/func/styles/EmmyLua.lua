return {
	general = {
		layout = { "---", "---" },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = false,
			gap_text = "--",
		},
		section = {
			gap = false,
			gap_text = "--",
			underline_char = "",
			title_gap = false,
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		section_title = "",
		inline = true,
		indent = false,
		include_type = false,
		template = {
			"@param %item_name",
		},
	},
	return_type = {
		section_title = "",
		inline = true,
		indent = false,
		include_type = false,
		template = {
			"@return",
		},
	},
}
