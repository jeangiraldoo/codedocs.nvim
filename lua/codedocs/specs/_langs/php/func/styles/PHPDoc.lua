return {
	general = {
		layout = {
			"/**",
			" */",
		},
		insert_at = 2,
		direction = true,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			" * ${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = true,
			text = " *",
		},
	},
	params = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			template = {
				" * @param ${%snippet_tabstop_idx:%item_type} \\$%item_name ${%snippet_tabstop_idx:description}",
			},
		},
	},
	return_type = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			template = {
				" * @return ${%snippet_tabstop_idx:%item_type} ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
