return {
	settings = {
		layout = {
			"/**",
			" */",
		},
		insert_at = 2,
		relative_position = "above",
		section_order = {
			"parameters",
			"returns",
		},
	},
	sections = {
		title = {
			layout = {
				" * ${%snippet_tabstop_idx:title}",
			},
			insert_gap_between = {
				enabled = true,
				text = " *",
			},
		},
		parameters = {
			layout = {},
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			items = {
				layout = {
					" * @param ${%snippet_tabstop_idx:%item_type} \\$%item_name ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				indent = false,
			},
		},
		returns = {
			layout = {},
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			items = {
				layout = {
					" * @return ${%snippet_tabstop_idx:%item_type} ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				indent = false,
			},
		},
	},
}
