return {
	general = {
		layout = { '"""', "", '"""' },
		direction = false,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = "",
		},
		section_order = {
			"params",
			"return_type",
		},
	},
	params = {
		layout = {
			"Parameters",
			"----------",
		},
		gap = {
			enabled = true,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = false,
			include_type = true,
			template = {
				{ "%item_name : ", "%item_type" },
			},
		},
	},
	return_type = {
		layout = {
			"Returns",
			"-------",
		},
		gap = {
			enabled = true,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = false,
			include_type = true,
			template = {
				"%item_type",
			},
		},
	},
}
