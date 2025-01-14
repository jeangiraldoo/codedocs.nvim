local opts = require("codedocs.styles.opts")

return {
	Google = {
		class = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = false,
			[opts.func.section_underline.val] = "",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.class.attrs_title.val] = "Attributes:",
			[opts.class.attr_inline.val] = true,
			[opts.class.attr_indent.val] = true,
			[opts.class.include_attr_type.val] = true,
			[opts.class.attr_type_first.val] = false,
			[opts.class.attr_kw.val] = "",
			[opts.class.attr_type_kw.val] = "",
			[opts.class.attr_name_wrapper.val] = {"", ""},
			[opts.class.attr_type_wrapper.val] = {"(", "):"},
			[opts.class.is_type_below_name_first.val] = false,
		},
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
		class = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = false,
			[opts.func.section_underline.val] = "_",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.class.attrs_title.val] = "Attributes:",
			[opts.class.attr_inline.val] = true,
			[opts.class.attr_indent.val] = false,
			[opts.class.include_attr_type.val] = true,
			[opts.class.attr_type_first.val] = false,
			[opts.class.attr_kw.val] = "",
			[opts.class.attr_type_kw.val] = "",
			[opts.class.attr_name_wrapper.val] = {"", ""},
			[opts.class.attr_type_wrapper.val] = {"", ":"},
			[opts.class.is_type_below_name_first.val] = false,
		},
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
		class = {
			[opts.func.struct.val] = {'"""', "", '"""'},
			[opts.func.direction.val] = false,
			[opts.func.title_pos.val] = 2,
			[opts.func.title_gap.val] = true,
			[opts.func.section_gap.val] = false,
			[opts.func.section_underline.val] = "",
			[opts.func.section_title_gap.val] = false,
			[opts.func.item_gap.val] = false,

			[opts.class.attrs_title.val] = "",
			[opts.class.attr_inline.val] = false,
			[opts.class.attr_indent.val] = false,
			[opts.class.include_attr_type.val] = true,
			[opts.class.attr_type_first.val] = false,
			[opts.class.attr_kw.val] = ":param",
			[opts.class.attr_type_kw.val] = ":type",
			[opts.class.attr_name_wrapper.val] = {"", ":"},
			[opts.class.attr_type_wrapper.val] = {"", ""},
			[opts.class.is_type_below_name_first.val] = true,
		},
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
