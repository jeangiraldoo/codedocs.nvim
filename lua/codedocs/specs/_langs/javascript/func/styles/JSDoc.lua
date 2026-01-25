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
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			insert_gap_between = false,
			indent = false,
			include_type = false,
			template = {
				"@param {%item_type} %item_name",
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
			insert_gap_between = false,
			indent = false,
			include_type = false,
			template = {
				"@returns {%item_type}",
			},
		},
	},
}
