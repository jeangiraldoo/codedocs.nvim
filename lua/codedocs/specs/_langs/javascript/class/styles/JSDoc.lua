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
			" * ${%snippet_tabstop_idx:title}",
		},
		gap = {
			enabled = true,
			text = " *",
		},
	},
	attrs = {
		layout = {},
		gap = {
			enabled = false,
			text = " *",
		},
		include_class_attrs = false,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = false,
		items = {
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			template = {
				" * @property {%item_type} %item_name ${%snippet_tabstop_idx:description}",
			},
		},
	},
}
