return {
	settings = {
		layout = {},
		relative_position = "above",
		insert_at = 1,
		section_order = {
			"parameters",
			"returns",
		},
	},
	sections = {
		title = {
			layout = {
				"--- ${%snippet_tabstop_idx:title}",
			},
			insert_gap_between = {
				enabled = false,
				text = "--",
			},
		},
		parameters = {
			layout = {},
			insert_gap_between = {
				enabled = false,
				text = "--",
			},
			items = {
				layout = {
					"-- @param %item_name ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
				indent = false,
			},
		},
		returns = {
			layout = {},
			insert_gap_between = {
				enabled = false,
				text = "--",
			},
			items = {
				layout = {
					"-- @return ${%snippet_tabstop_idx:type} ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "--",
				},
				indent = false,
			},
		},
	},
}
