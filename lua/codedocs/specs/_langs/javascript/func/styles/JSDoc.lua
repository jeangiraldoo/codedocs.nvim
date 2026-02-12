return {
	settings = {
		layout = {
			"/**",
			" */",
		},
		direction = true,
		insert_at = 2,
		section_order = {
			"parameters",
			"returns",
		},
	},
	sections = {
		title = {
			layout = {
				" * ${%snippet_tabstop_idx:description}",
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
		returns = {
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
	},
}
