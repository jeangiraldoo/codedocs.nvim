return {
	general = {
		layout = { "# ", "# " },
		direction = true,
		annotation_title = {
			pos = 1,
			gap = true,
			gap_text = "#",
		},
		section = {
			gap = false,
			gap_text = "#",
			underline_char = "",
			title_gap = false,
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		section_title = "",
		indent = false,
		include_type = false,
		template = {
			"@param %item_name [%item_type]",
		},
	},
	return_type = {
		section_title = "",
		indent = false,
		include_type = false,
		template = {
			"@return [%item_type]",
		},
	},
}
