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
		item_extraction = {
			attrs = {
				include_class_attrs = true,
				include_instance_attrs = true,
				include_only_constructor_instance_attrs = true,
			},
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
				":vartype %item_name: ${%snippet_tabstop_idx:%item_type}",
			},
		},
	},
}
