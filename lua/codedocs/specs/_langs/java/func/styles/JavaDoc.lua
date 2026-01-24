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
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {},
		indent = false,
		template = {
			"@param %item_name",
		},
	},
	return_type = {
		layout = {},
		indent = false,
		template = {
			"@return",
		},
	},
}
