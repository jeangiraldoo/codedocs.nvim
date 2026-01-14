return {
	general = {
		struct = { "/**", " * ", " */" },
		direction = true,
		title_pos = 2,
		title_gap = true,
		section_gap = false,
		section_underline = "",
		section_title_gap = false,
		item_gap = false,
		section_order = { "attrs" },
		include_class_body_attrs = false,
		include_instance_attrs = false,
		-- Java attrs can only be declared in the class body
		include_only_constructor_instance_attrs = nil,
	},
	attrs = {
		title = "Attributes:",
		inline = true,
		indent = false,
		include_type = false,
		type_first = false,
		name_kw = "",
		type_kw = "",
		name_wrapper = { "- ", ": " },
		type_wrapper = { "", "" },
		is_type_below_name_first = false,
	},
}
