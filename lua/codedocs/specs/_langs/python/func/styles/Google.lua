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
		gap = {
			enabled = false,
			text = "",
		},
		items = {
			indent = true,
			include_type = true,
			template = {
				"%item_name (%item_type):",
			},
		},
	},
	return_type = {
		layout = {
			"Returns:",
		},
		gap = {
			enabled = false,
			text = "",
		},
		items = {
			indent = true,
			include_type = true,
			template = {
				"%item_type:",
			},
		},
	},
}
