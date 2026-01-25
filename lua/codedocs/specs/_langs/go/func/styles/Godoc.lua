return {
	general = {
		layout = {
			"// ",
			"// ",
		},
		direction = true,
		annotation_title = {
			pos = 1,
			gap = true,
			gap_text = "//",
		},
		section = {
			order = {
				"params",
				"return_type",
			},
		},
		item_gap = false,
	},
	params = {
		layout = {
			"Parameters:",
		},
		indent = false,
		gap = {
			enabled = true,
			text = "//",
		},
		template = {
			"- %item_name:",
		},
	},
	return_type = {
		layout = {
			"Returns:",
		},
		indent = false,
		gap = {
			enabled = true,
			text = "//",
		},
		template = {
			"",
		},
	},
}
