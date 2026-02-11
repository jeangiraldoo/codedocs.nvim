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
		insert_gap_between = {
			enabled = true,
			text = "",
		},
	},
	params = {
		layout = {
			"Args:",
		},
		insert_gap_between = {
			enabled = true,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = true,
			template = {
				"%item_name (${%snippet_tabstop_idx:%item_type}): ${%snippet_tabstop_idx:description}",
			},
		},
	},
	return_type = {
		layout = {
			"Returns:",
		},
		insert_gap_between = {
			enabled = false,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = true,
			template = {
				"${%snippet_tabstop_idx:%item_type}: ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
