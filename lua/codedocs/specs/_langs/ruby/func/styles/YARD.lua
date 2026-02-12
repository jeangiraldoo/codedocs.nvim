return {
	general = {
		layout = {},
		direction = true,
		insert_at = 1,
		section_order = {
			"parameters",
			"returns",
		},
	},
	title = {
		layout = {
			"# ${%snippet_tabstop_idx:title}",
		},
		insert_gap_between = {
			enabled = true,
			text = "#",
		},
	},
	parameters = {
		layout = {},
		insert_gap_between = {
			enabled = false,
			text = "#",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "#",
			},
			indent = false,
			template = {
				"# @param %item_name [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
			},
		},
	},
	returns = {
		layout = {},
		insert_gap_between = {
			enabled = false,
			text = "#",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "#",
			},
			indent = false,
			template = {
				"# @return [${%snippet_tabstop_idx:type}] ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
