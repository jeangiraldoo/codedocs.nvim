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
		layout = {},
		include_class_attrs = false,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = false,
		indent = false,
		gap = {
			enabled = false,
			text = " *",
		},
		format = {
			"@property %item_name",
		},
	},
}
