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
				"/// ${%snippet_tabstop_idx:title}",
			},
			insert_gap_between = {
				enabled = true,
				text = "///",
			},
		},
		parameters = {
			layout = {
				"/// # Arguments",
				"///",
			},
			insert_gap_between = {
				enabled = true,
				text = "///",
			},
			items = {
				layout = {
					"/// * `%item_name` - ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "///",
				},
				indent = false,
			},
		},
		returns = {
			layout = {
				"/// # Returns",
				"///",
			},
			insert_gap_between = {
				enabled = true,
				text = "///",
			},
			items = {
				layout = {
					"/// ${%snippet_tabstop_idx:description}",
				},
				insert_gap_between = {
					enabled = false,
					text = "///",
				},
				indent = false,
			},
		},
	},
}
