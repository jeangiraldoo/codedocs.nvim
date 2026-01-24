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
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {},
		indent = false,
		include_type = true,
		template = {
			":param %item_name:",
			":type %item_name:",
		},
	},
	return_type = {
		layout = {},
		indent = false,
		include_type = true,
		template = {
			":return:",
			{ ":rtype:", "%item_type" },
		},
	},
}
