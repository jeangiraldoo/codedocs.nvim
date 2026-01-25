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
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			indent = false,
			include_type = true,
			template = {
				{ "@param", "%item_type", "%item_name" },
			},
		},
	},
	return_type = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				"@return",
			},
		},
	},
}
