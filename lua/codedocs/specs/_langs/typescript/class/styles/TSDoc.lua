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
			"Properties:",
		},
		include_class_attrs = true,
		include_instance_attrs = false,
		include_only_constructor_instance_attrs = false,
		indent = false,
		item_name = {
			keyword = "",
			delimiters = { "- `", "`" },
		},
		item_type = {
			include = false,
			is_before_name = false,
			keyword = "",
			delimiters = { "", "" },
		},
		is_type_below_name_first = false,
	},
}
