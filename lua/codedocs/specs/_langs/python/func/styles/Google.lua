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
		layout = {
			"Args:",
		},
		indent = true,
		include_type = true,
		gap = {
			enabled = false,
			text = "",
		},
		template = {
			"%item_name (%item_type):",
		},
	},
	return_type = {
		layout = {
			"Returns:",
		},
		indent = true,
		include_type = true,
		gap = {
			enabled = false,
			text = "",
		},
		template = {
			"%item_type:",
		},
	},
}
