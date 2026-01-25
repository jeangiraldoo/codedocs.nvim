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
		section_order = {
			"params",
			"return_type",
		},
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
			insert_gap_between = false,
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
			insert_gap_between = false,
			indent = false,
			include_type = false,
			template = {
				"%item_type",
			},
		},
	},
}
