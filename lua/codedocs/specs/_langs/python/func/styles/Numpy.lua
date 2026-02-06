return {
	general = {
		layout = {
			'"""',
			'"""',
		},
		direction = false,
		insert_at = 2,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			"${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = true,
			text = "",
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
