return {
	general = {
		layout = {
			'"""',
			'"""',
		},
		direction = false,
		insert_at = 2,
		section_order = {
			"attrs",
		},
	},
	title = {
		layout = {
			"",
		},
		cursor_pos = 1,
		gap = {
			enabled = true,
			text = "",
		},
	},
	attrs = {
		layout = {},
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
			indent = false,
			include_type = true,
			template = {
				{ ":var", "%item_name:" },
				{ ":vartype", "%item_name:", "%item_type" },
			},
		},
	},
}
