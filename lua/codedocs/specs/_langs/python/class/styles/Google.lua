return {
	general = {
		layout = { '"""', "", '"""' },
		direction = false,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = "",
		},
		section = {
			gap = false,
			gap_text = "",
			underline_char = "",
			title_gap = false,
			order = { "attrs" },
		},
		item_gap = false,
	},
	attrs = {
		section_title = "Attributes:",
		include_class_attrs = true,
		include_instance_attrs = true,
		include_only_constructor_instance_attrs = true,
		indent = true,
		include_type = true,
		template = {
			"%item_name (%item_type):",
		},
	},
}
