return {
	general = {
		layout = { "/**", " * ", " */" },
		direction = true,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = " *",
		},
		section = {
			order = { "attrs" },
		},
		item_gap = false,
	},
	attrs = {
		layout = {
			"Properties:",
		},
		include_class_attrs = true,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = false,
		gap = {
			enabled = false,
			text = " *",
		},
		items = {
			indent = false,
			include_type = false,
			template = {
				"- `%item_name`",
			},
		},
	},
}
