return {
	settings = {
		layout = {
			'"""',
			'"""',
		},
		relative_position = "below",
		insert_at = 2,
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
				"___________",
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
				indent = false,
				template = {
					{ "%item_name :", "%item_type" },
				},
			},
		},
	},
}
