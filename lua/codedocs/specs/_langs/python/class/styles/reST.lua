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
			"${%snippet_tabstop_idx:title}",
		},
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
			template = {
				":var %item_name: ${%snippet_tabstop_idx:description}",
				{ ":vartype", "%item_name:", "%item_type" },
			},
		},
	},
}
