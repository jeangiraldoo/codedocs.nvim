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
			gap = false,
			gap_text = " *",
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
		template = {
			"- %item_name:",
		},
	},
}
