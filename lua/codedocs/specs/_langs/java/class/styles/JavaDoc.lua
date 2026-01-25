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
			"Attributes:",
		},
		include_class_attrs = false,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = nil, -- Java attrs can only be declared in the class body
		indent = false,
		gap = {
			enabled = false,
			text = " *",
		},
		template = {
			"- %item_name:",
		},
	},
}
