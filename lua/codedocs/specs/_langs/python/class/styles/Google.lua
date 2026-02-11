return {
	general = {
		layout = {
			'"""',
			'"""',
		},
		insert_at = 2,
		direction = false,
		section_order = {
			"attrs",
		},
	},
	title = {
		layout = {
			"${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = true,
			text = "",
		},
	},
	attrs = {
		layout = {
			"Attributes:",
		},
		include_class_attrs = true,
		include_instance_attrs = true,
		include_only_constructor_instance_attrs = true,
		gap = {
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
}
