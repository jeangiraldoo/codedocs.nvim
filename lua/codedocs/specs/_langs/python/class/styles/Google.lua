return {
	settings = {
		layout = {
			'"""',
			'"""',
		},
		insert_at = 2,
		relative_position = "below",
		section_order = {
			"attrs",
		},
		item_extraction = {
			attrs = {
				include_class_attrs = true,
				include_instance_attrs = true,
				include_only_constructor_instance_attrs = true,
			},
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
		attrs = {
			layout = {
				"Attributes:",
			},
			insert_gap_between = {
				enabled = false,
				text = "",
			},
			items = {
				insert_gap_between = {
					enabled = false,
					text = "",
				},
				indent = true,
				template = {
					"%item_name (%item_type): ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
}
