local opts = require("codedocs.styles.opts")

return {
	Google = {
		func = {
			[opts.struct.val] = {'"""', "", '"""'},
			[opts.direction.val] = false,
			[opts.title_pos.val] = 2,
			[opts.empty_ln_after_title.val] = true,
			[opts.empty_ln_after_section_title.val] = false,
			[opts.empty_ln_between_sections.val] = false,
			[opts.empty_ln_after_section_item] = false,
			[opts.section_underline.val] = "",
			[opts.is_type_in_docs.val] = true,
			[opts.type_goes_first.val] = false,
			[opts.params_title.val] = "Args:",
			[opts.is_param_one_ln.val] = true,
			[opts.is_type_below_name_first.val] = false,
			[opts.param_kw.val] = "",
			[opts.param_indent.val] = true,
			[opts.name_wrapper.val] = {"", ""},
			[opts.type_wrapper.val] = {"(", "):"},
			[opts.return_title.val] = "Returns:",
			[opts.return_kw.val] = "",
			[opts.return_type_kw.val] = "",
			[opts.is_return_type_in_docs.val] = true,
			[opts.type_wrapper.val] = {"", ":"}
		}
	},
	Numpy = {
		func = {
			[opts.struct.val] = {'"""', "", '"""'},
			[opts.direction.val] = false,
			[opts.title_pos.val] = 2,
			[opts.empty_ln_after_title.val] = true,
			[opts.empty_ln_after_section_title.val] = false,
			[opts.empty_ln_between_sections.val] = false,
			[opts.empty_ln_after_section_item.val] = false,
			[opts.section_underline.val] = "-",
			[opts.params_title.val] = "Parameters",
			[opts.is_type_in_docs.val] = true,
			[opts.type_goes_first.val] = false,
			[opts.is_param_one_ln.val] = true,
			[opts.is_type_in_docs.val] = true,
			[opts.return_title.val] = "Returns",
			[opts.is_type_below_name_first.val] = false,
			[opts.param_kw.val] = "",
			[opts.type_kw.val] = "",
			[opts.param_kw.val] = "",
			[opts.type_kw.val] = "",
			[opts.param_indent.val] = false,
			[opts.name_wrapper.val] = {"", ""},
			[opts.type_wrapper.val] = {": ", ""},
			[opts.is_return_type_in_docs.val] = true,
			[opts.return_type_wrapper.val] = {"", ""}
		}
	},
	reST = {
		func = {
			[opts.struct.val] = {'"""', "", '"""'},
			[opts.is_type_in_docs.val] = true,
			[opts.is_type_in_docs.val] = true,
			[opts.type_goes_first.val] = false,
			[opts.direction.val] = false,
			[opts.title_pos.val] = 2,
			[opts.empty_ln_after_title.val] = true,
			[opts.empty_ln_after_section_title.val] = false,
			[opts.empty_ln_between_sections.val] = false,
			[opts.empty_ln_after_section_item.val] = false,
			[opts.section_underline.val] = "",
			[opts.params_title.val] = "",
			[opts.return_title.val] = "",
			[opts.is_param_one_ln.val] = false,
			[opts.is_type_below_name_first.val] = true,
			[opts.param_kw.val] = ":param",
			[opts.type_kw.val] = ":type",
			[opts.return_kw.val] = ":return:",
			[opts.return_type_kw.val] = ":rtype:",
			[opts.param_indent.val] = false,
			[opts.name_wrapper.val] = {"", ":"},
			[opts.return_type_wrapper.val] = {"", ""},
			[opts.is_return_type_in_docs.val] = true,
			[opts.type_wrapper.val] = {"", ""}
		},
		unknown = {
			[opts.struct.val] = {'"""', "", '"""'},
			[opts.title_pos.val] = 1
		}
	}
}
