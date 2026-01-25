return {
	general = {
		layout = { "/**", " * ", " */" },
		direction = true,
		annotation_title = {
			pos = 2,
			gap = true,
			gap_text = " *",
		},
		section_order = {
			"attrs",
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
			insert_gap_between = false,
			indent = false,
			include_type = false,
			format = {
				{ "@property %item_name", "%item_type" },
			},
		},
	},
}
