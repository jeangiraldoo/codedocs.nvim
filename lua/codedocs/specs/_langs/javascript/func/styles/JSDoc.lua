return {
	general = {
		layout = {
			"/**",
			" */",
		},
		direction = true,
		insert_at = 2,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			" * ${%snippet_tabstop_idx:description}",
		},
		insert_gap_between = {
			enabled = true,
			text = " *",
		},
	},
	params = {
		layout = {},
		insert_gap_between = {
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
				" * @param {${%snippet_tabstop_idx:type}} %item_name ${%snippet_tabstop_idx:description}",
			},
		},
	},
	return_type = {
		layout = {},
		insert_gap_between = {
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
				" * @returns {${%snippet_tabstop_idx:type}} ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
