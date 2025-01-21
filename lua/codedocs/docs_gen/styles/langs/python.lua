local opts = require("codedocs.docs_gen.styles.opts")
local general = opts.general
local item = opts.item

return {
	Google = {
		class = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = false,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"attrs"}
			},
			attrs = {
				[item.title.val] = "Attributes:",
				[item.inline.val] = true,
				[item.indent.val] = true,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"(", "):"},
				[item.is_type_below_name_first.val] = false,
			}
		},
		func = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = false,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"params", "return_type"}
			},
			params = {
				[item.title.val] = "Args:",
				[item.inline.val] = true,
				[item.indent.val] = true,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"(", "):"},
				[item.is_type_below_name_first.val] = false,
			},
			return_type = {
				[item.title.val] = "Returns:",
				[item.inline.val] = true,
				[item.indent.val] = true,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"", ":"},
				[item.is_type_below_name_first.val] = false,
			}
		},
		generic = {
			general = {
				[general.struct.val] = {"# "},
				[general.title_pos.val] = 1,
				[general.direction.val] = true
			}
		}
	},
	Numpy = {
		class = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = false,
				[general.section_underline.val] = "_",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"attrs"}
			},
			attrs = {
				[item.title.val] = "Attributes:",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"", ":"},
				[item.is_type_below_name_first.val] = false,
			}
		},
		func = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = true,
				[general.section_underline.val] = "-",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"params", "return_type"}
			},
			params = {
				[item.title.val] = "Parameters",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {": ", ""},
				[item.is_type_below_name_first.val] = false,
			},
			return_type = {
				[item.title.val] = "Returns",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = false,
			}
		},
		generic = {
			general = {
				[general.struct.val] = {"# "},
				[general.title_pos.val] = 1,
				[general.direction.val] = true
			}
		}
	},
	reST = {
		class = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = false,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"attrs"}
			},
			attrs = {
				[item.title.val] = "",
				[item.inline.val] = false,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = ":param",
				[item.type_kw.val] = ":type",
				[item.name_wrapper.val] = {"", ":"},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = true,
			}
		},
		func = {
			general = {
				[general.struct.val] = {'"""', "", '"""'},
				[general.direction.val] = false,
				[general.title_pos.val] = 2,
				[general.title_gap.val] = true,
				[general.section_gap.val] = false,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = false,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"params", "return_type"}
			},
			params = {
				[item.title.val] = "",
				[item.inline.val] = false,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = ":param",
				[item.type_kw.val] = ":type",
				[item.name_wrapper.val] = {"", ":"},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = true,
			},
			return_type = {
				[item.title.val] = "",
				[item.inline.val] = false,
				[item.indent.val] = false,
				[item.include_type.val] = true,
				[item.type_first.val] = false,
				[item.kw.val] = ":return:",
				[item.type_kw.val] = ":rtype:",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = true,
			}
		},
		generic = {
			general = {
				[general.struct.val] = {"# "},
				[general.title_pos.val] = 1,
				[general.direction.val] = true
			}
		}
	}
}
