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
			gap = true,
			gap_text = "",
			order = { "params", "return_type" },
		},
		item_gap = false,
	},
	params = {
		layout = {
			"Parameters",
			"----------",
		},
		indent = false,
		include_type = true,
		template = {
			{ "%item_name : ", "%item_type" },
		},
	},
	return_type = {
		layout = {
			"Returns",
			"-------",
		},
		indent = false,
		include_type = true,
		template = {
			"%item_type",
		},
	},
}
