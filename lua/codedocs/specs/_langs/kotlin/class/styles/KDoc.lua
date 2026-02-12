return {
	settings = {
		layout = {
			"/**",
			" */",
		},
		direction = true,
		insert_at = 2,
		section_order = {
			"attrs",
		},
		item_extraction = {
			attrs = {
				include_class_attrs = false,
				include_instance_attrs = false,
				include_only_constructor_instance_attrs = false,
			},
		},
	},
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
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			template = {},
		},
	},
}
