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
			" * Attributes:",
		},
		gap = {
			enabled = false,
			text = " *",
		},
		include_class_attrs = false,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = nil, -- Java attrs can only be declared in the class body
		items = {
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			include_type = false,
			template = {
				{ " * - %item_name:", "%item_type" },
			},
		},
	},
}
