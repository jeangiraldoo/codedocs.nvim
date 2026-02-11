return {
	general = {
		layout = {
			'"""',
			'"""',
		},
		direction = false,
		insert_at = 2,
		section_order = {
			"parameters",
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
	parameters = {
		layout = {},
		insert_gap_between = {
			enabled = false,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = false,
			template = {
				":param %item_name: ${%snippet_tabstop_idx:description}",
				":type %item_name: ${%snippet_tabstop_idx:%item_type}",
			},
		},
	},
	return_type = {
		layout = {},
		insert_gap_between = {
			enabled = false,
			text = "",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			indent = false,
			template = {
				":return: ${%snippet_tabstop_idx:description}",
				":rtype: ${%snippet_tabstop_idx:%item_type}",
			},
		},
	},
}
