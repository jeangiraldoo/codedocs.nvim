return {
	general = {
		layout = { '"""', "", '"""' },
		direction = false,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = "",
		},
		section_order = {
			"attrs",
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
			include_type = true,
			template = {
				"%item_name (%item_type):",
			},
		},
	},
}
