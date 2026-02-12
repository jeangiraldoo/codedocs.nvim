return {
	settings = {
		layout = {
			'"""',
			'"""',
		},
		direction = false,
		insert_at = 2,
		section_order = {
			"parameters",
			"returns",
		},
	},
	sections = {
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
		returns = {
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
	},
}
