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
				"Parameters",
				"----------",
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
				indent = false,
				template = {
					"%item_name: ${%snippet_tabstop_idx:%item_type}",
					"	${%snippet_tabstop_idx:description}",
				},
			},
		},
		returns = {
			layout = {
				"Returns",
				"-------",
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
				indent = false,
				template = {
					"${%snippet_tabstop_idx:%item_type}",
					"	${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
}
