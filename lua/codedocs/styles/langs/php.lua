local opts = require("codedocs.styles.opts")

return {
	PHPDoc = {
		func = {
			[opts.struct.val] = {"/**", " * ", " */"},
			[opts.is_type_in_docs.val] = true,
			[opts.is_return_type_in_docs.val] = true,
			[opts.type_goes_first.val] = true,
			[opts.direction.val] = true,
			[opts.title_pos.val] = 2,
			[opts.empty_ln_after_title.val] = true,
			[opts.empty_ln_after_section_title.val] = false,
			[opts.empty_ln_between_sections.val] = false,
			[opts.empty_ln_after_section_item.val] = false,
			[opts.section_underline.val] = "",
			[opts.params_title.val] = "",
			[opts.return_title.val] = "",
			[opts.is_param_one_ln.val] = true,
			[opts.is_type_below_name_first.val] = false,
			[opts.param_kw.val] = "",
			[opts.type_kw.val] = "@param",
			[opts.return_kw.val] = "@return",
			[opts.return_type_kw.val] = "",
			[opts.param_indent.val] = false,
			[opts.name_wrapper.val] = {"", ""},
			[opts.type_wrapper.val] = {"", ""},
			[opts.return_type_wrapper.val] = {"", ""}
		}
	}
}
