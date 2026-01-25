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
		gap = {
			enabled = true,
			text = "//",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				{ "- %item_name:", "%item_type" },
			},
		},
	},
	return_type = {
		layout = {
			"Returns:",
		},
		gap = {
			enabled = true,
			text = "//",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				"%item_type",
			},
		},
	},
}
