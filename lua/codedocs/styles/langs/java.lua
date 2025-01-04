local opts = require("codedocs.styles.opts")

return {
	JavaDoc = {
		func = {
			[opts.func.struct.val] = {"/**", " * ", " */"},
			[opts.func.is_type_in_docs.val] = false,
			[opts.func.is_return_type_in_docs.val] = false,
			[opts.func.type_goes_first.val] = false,
			[opts.func.direction.val] = true,
			[opts.func.title_pos.val] = 2,
			[opts.func.empty_ln_after_title.val] = true,
			[opts.func.empty_ln_after_section_title.val] = false,
			[opts.func.empty_ln_between_sections.val] = false,
			[opts.func.empty_ln_after_section_item.val] = false,
			[opts.func.section_underline.val] = "",
			[opts.func.params_title.val] = "",
			[opts.func.return_title.val] = "",
			[opts.func.is_param_one_ln.val] = true,
			[opts.func.is_type_below_name_first.val] = false,
			[opts.func.param_kw.val] = "@param",
			[opts.func.type_kw.val] = "",
			[opts.func.return_kw.val] = "@return",
			[opts.func.return_type_kw.val] = "",
			[opts.func.param_indent.val] = false,
			[opts.func.name_wrapper.val] = {"", ""},
			[opts.func.type_wrapper.val] = {"", ""},
			[opts.func.is_return_one_ln.val] = true,
			[opts.func.return_type_wrapper.val] = {"", ""}
		}
	}

}

