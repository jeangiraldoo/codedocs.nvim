return {
	settings = {
		layout = {
			"/**",
			" */",
		},
		relative_position = "above",
		insert_at = 2,
		section_order = {
			"attrs",
		},
		item_extraction = {
			attrs = {
				include_class_attrs = true,
				include_instance_attrs = false,
				include_only_constructor_instance_attrs = false,
			},
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
		attrs = {
			layout = {},
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			items = {
				layout = {},
				insert_gap_between = {
					enabled = false,
					text = " *",
				},
				indent = false,
			},
		},
	},
}
