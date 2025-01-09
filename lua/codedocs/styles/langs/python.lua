local opts = require("codedocs.styles.opts")

return {
	Google = {
		func = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = false,
			[opts.func.section_underline.val] = "",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.func.params_title.val] = "Args:",
			[opts.func.param_inline.val] = true,
			[opts.func.param_indent.val] = true,
			[opts.func.include_param_type.val] = true,
			[opts.func.param_type_first.val] = false,
			[opts.func.param_kw.val] = "",
			[opts.func.param_type_kw.val] = "",
			[opts.func.param_name_wrapper.val] = {"", ""},
			[opts.func.param_type_wrapper.val] = {"(", "):"},
			[opts.func.is_type_below_name_first.val] = false,

			[opts.func.return_title.val] = "Returns:",
			[opts.func.return_inline.val] = true,
			[opts.func.include_return_type.val] = true,
			[opts.func.return_kw.val] = "",
			[opts.func.return_type_kw.val] = "",
			[opts.func.return_type_wrapper.val] = {"", ":"}
		},
		generic = {
			[opts.generic.struct.val] = {"# "},
			[opts.generic.title_pos.val] = 1,
			[opts.generic.direction.val] = true
		}
	},
	Numpy = {
		func = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = true,
			[opts.func.section_underline.val] = "-",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.func.params_title.val] = "Parameters",
			[opts.func.param_inline.val] = true,
			[opts.func.param_indent.val] = false,
			[opts.func.include_param_type.val] = true,
			[opts.func.param_type_first.val] = false,
			[opts.func.param_kw.val] = "",
			[opts.func.param_type_kw.val] = "",
			[opts.func.param_name_wrapper.val] = {"", ""},
			[opts.func.param_type_wrapper.val] = {": ", ""},
			[opts.func.is_type_below_name_first.val] = false,

			[opts.func.return_title.val] = "Returns",
			[opts.func.return_inline.val] = true,
			[opts.func.include_return_type.val] = true,
			[opts.func.return_kw.val] = "",
			[opts.func.return_type_kw.val] = "",
			[opts.func.return_type_wrapper.val] = {"", ""}
		},
		generic = {
			[opts.generic.struct.val] = {"# "},
			[opts.generic.title_pos.val] = 1,
			[opts.generic.direction.val] = true
		}
	},
	reST = {
		func = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = false,
			[opts.func.section_underline.val] = "",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.func.params_title.val] = "",
			[opts.func.param_inline.val] = false,
			[opts.func.param_indent.val] = false,
			[opts.func.include_param_type.val] = true,
			[opts.func.param_type_first.val] = false,
			[opts.func.param_kw.val] = ":param",
			[opts.func.param_type_kw.val] = ":type",
			[opts.func.param_name_wrapper.val] = {"", ":"},
			[opts.func.param_type_wrapper.val] = {"", ""},
			[opts.func.is_type_below_name_first.val] = true,

			[opts.func.return_title.val] = "",
			[opts.func.return_inline.val] = false,
			[opts.func.include_return_type.val] = true,
			[opts.func.return_kw.val] = ":return:",
			[opts.func.return_type_kw.val] = ":rtype:",
			[opts.func.return_type_wrapper.val] = {"", ""},
		},
		generic = {
			[opts.generic.struct.val] = {"# "},
			[opts.generic.title_pos.val] = 1,
			[opts.generic.direction.val] = true
		}
	}
}
