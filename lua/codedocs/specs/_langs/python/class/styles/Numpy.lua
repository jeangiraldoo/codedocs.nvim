return function(opts)
	return {
		general = {
			[opts.struct.val] = { '"""', "", '"""' },
			[opts.direction.val] = false,
			[opts.title_pos.val] = 2,
			[opts.title_gap.val] = true,
			[opts.section_gap.val] = false,
			[opts.section_underline.val] = "_",
			[opts.section_title_gap.val] = false,
			[opts.item_gap.val] = false,
			[opts.section_order.val] = { "attrs" },
			[opts.include_class_body_attrs.val] = true,
			[opts.include_instance_attrs.val] = true,
			[opts.include_only_constructor_instance_attrs.val] = true,
		},
		attrs = {
			[opts.title.val] = "Attributes:",
			[opts.inline.val] = true,
			[opts.indent.val] = false,
			[opts.include_type.val] = true,
			[opts.type_first.val] = false,
			[opts.name_kw.val] = "",
			[opts.type_kw.val] = "",
			[opts.name_wrapper.val] = { "", "" },
			[opts.type_wrapper.val] = { "", ":" },
			[opts.is_type_below_name_first.val] = false,
		},
	}
end
