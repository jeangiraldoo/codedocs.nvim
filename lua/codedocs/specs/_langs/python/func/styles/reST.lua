return function(opts)
	return {
		general = {
			[opts.struct.val] = { '"""', "", '"""' },
			[opts.direction.val] = false,
			[opts.title_pos.val] = 2,
			[opts.title_gap.val] = true,
			[opts.section_gap.val] = false,
			[opts.section_underline.val] = "",
			[opts.section_title_gap.val] = false,
			[opts.item_gap.val] = false,
			[opts.section_order.val] = { "params", "return_type" },
		},
		params = {
			[opts.title.val] = "",
			[opts.inline.val] = false,
			[opts.indent.val] = false,
			[opts.include_type.val] = true,
			[opts.type_first.val] = false,
			[opts.name_kw.val] = ":param",
			[opts.type_kw.val] = ":type",
			[opts.name_wrapper.val] = { "", ":" },
			[opts.type_wrapper.val] = { "", "" },
			[opts.is_type_below_name_first.val] = true,
		},
		return_type = {
			[opts.title.val] = "",
			[opts.inline.val] = false,
			[opts.indent.val] = false,
			[opts.include_type.val] = true,
			[opts.type_first.val] = false,
			[opts.name_kw.val] = ":return:",
			[opts.type_kw.val] = ":rtype:",
			[opts.name_wrapper.val] = { "", "" },
			[opts.type_wrapper.val] = { "", "" },
			[opts.is_type_below_name_first.val] = true,
		},
	}
end
