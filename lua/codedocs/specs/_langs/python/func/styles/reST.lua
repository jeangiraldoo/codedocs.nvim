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
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {},
		indent = false,
		include_type = true,
		gap = {
			enabled = false,
			text = "",
		},
		template = {
			":param %item_name:",
			":type %item_name:",
		},
	},
	return_type = {
		layout = {},
		indent = false,
		include_type = true,
		gap = {
			enabled = false,
			text = "",
		},
		template = {
			":return:",
			{ ":rtype:", "%item_type" },
		},
	},
}
