return function(opts)
	return {
		general = {
			[opts.struct.val] = { "/**", " * ", " */" },
			[opts.direction.val] = true,
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
			[opts.inline.val] = true,
			[opts.indent.val] = false,
			[opts.include_type.val] = true,
			[opts.type_first.val] = true,
			[opts.name_kw.val] = "",
			[opts.type_kw.val] = "@param",
			[opts.name_wrapper.val] = { "", "" },
			[opts.type_wrapper.val] = { "{", "}" },
			[opts.is_type_below_name_first.val] = false,
		},
		return_type = {
			[opts.title.val] = "",
			[opts.inline.val] = true,
			[opts.indent.val] = false,
			[opts.include_type.val] = false,
			[opts.type_first.val] = true,
			[opts.name_kw.val] = "",
			[opts.type_kw.val] = "@returns",
			[opts.name_wrapper.val] = { "", "" },
			[opts.type_wrapper.val] = { "{", "}" },
			[opts.is_type_below_name_first.val] = false,
		},
	}
end
