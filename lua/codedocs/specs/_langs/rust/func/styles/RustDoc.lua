return {
	general = {
		layout = {},
		direction = true,
		insert_at = 1,
		section_order = {
			"params",
			"return_type",
		},
	},
	title = {
		layout = {
			"/// ${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = true,
			text = "///",
		},
	},
	params = {
		layout = {
			"/// # Arguments",
			"///",
		},
		gap = {
			enabled = true,
			text = "///",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "///",
			},
			include_type = false,
			indent = false,
			template = {
				"/// * `%item_name` - ${%snippet_tabstop_idx:description}",
			},
		},
	},
	return_type = {
		layout = {
			"/// # Returns",
			"///",
		},
		gap = {
			enabled = true,
			text = "///",
		},
		items = {
			insert_gap_between = {
				enabled = false,
				text = "///",
			},
			indent = false,
			include_type = false,
			template = {
				"/// ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
