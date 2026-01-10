return function(opts)
	return {
		general = {
			[opts.struct.val] = { "// ", "// " },
			[opts.direction.val] = true,
			[opts.title_pos.val] = 1,
			[opts.title_gap.val] = true,
			[opts.section_gap.val] = true,
			[opts.section_underline.val] = "",
			[opts.section_title_gap.val] = false,
			[opts.item_gap.val] = false,
			[opts.section_order.val] = { "params", "return_type" },
		},
		params = {
			[opts.title.val] = "Parameters:",
			[opts.inline.val] = true,
			[opts.indent.val] = false,
			[opts.include_type.val] = false,
			[opts.type_first.val] = false,
			[opts.name_kw.val] = "",
			[opts.type_kw.val] = "",
			[opts.name_wrapper.val] = { "- ", ":" },
			[opts.type_wrapper.val] = { "", "" },
			[opts.is_type_below_name_first.val] = false,
		},
		return_type = {
			[opts.title.val] = "Returns:",
			[opts.inline.val] = true,
			[opts.indent.val] = false,
			[opts.include_type.val] = false,
			[opts.type_first.val] = false,
			[opts.name_kw.val] = "",
			[opts.type_kw.val] = "",
			[opts.name_wrapper.val] = { "", "" },
			[opts.type_wrapper.val] = { "", "" },
			[opts.is_type_below_name_first.val] = false,
		},
	}
end
