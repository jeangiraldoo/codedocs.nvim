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
		layout = {
			" * Attributes:",
		},
		gap = {
			enabled = false,
			text = " *",
		},
		include_class_attrs = false,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = nil, -- Java attrs can only be declared in the class body
		items = {
			insert_gap_between = {
				enabled = false,
				text = " *",
			},
			indent = false,
			include_type = false,
			template = {
				{ " * - %item_name:", "%item_type" },
			},
		},
	},
}
