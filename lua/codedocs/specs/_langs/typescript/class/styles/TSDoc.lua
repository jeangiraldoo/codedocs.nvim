return {
	general = {
		layout = {
			"/**",
			" */",
		},
		direction = true,
		insert_at = 2,
		section_order = {
			"attrs",
		},
	},
	title = {
		layout = {
			" * ",
		},
		cursor_pos = 1,
		gap = {
			enabled = true,
			text = " *",
		},
	},
	attrs = {
		layout = {
			" * Properties:",
		},
		include_class_attrs = true,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = false,
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
			include_type = false,
			template = {
				" * - `%item_name`",
			},
		},
	},
}
