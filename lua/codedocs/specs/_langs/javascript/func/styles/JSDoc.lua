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
		indent = false,
		include_type = false,
		gap = {
			enabled = false,
			text = " *",
		},
		template = {
			"@param {%item_type} %item_name",
		},
	},
	return_type = {
		layout = {},
		indent = false,
		gap = {
			enabled = false,
			text = " *",
		},
		include_type = false,
		template = {
			"@returns {%item_type}",
		},
	},
}
