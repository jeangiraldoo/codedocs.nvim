local opts = require("codedocs.styles.opts")
local general = opts.general
local item = opts.item

return {
	RustDoc = {
		class = {
			general = {
				[general.struct.val] = {"///", "///"},
				[general.direction.val] = true,
				[general.title_pos.val] = 1,
				[general.title_gap.val] = true,
				[general.section_gap.val] = true,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = true,
				[general.item_gap.val] = false,
			},
			attrs = {
				[item.title.val] = "",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = false,
				[item.type_first.val] = false,
				[item.kw.val] = "@param",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {"", ""},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = false,
			}
		},
		func = {
			general = {
				[general.struct.val] = {"///", "///"},
				[general.direction.val] = true,
				[general.title_pos.val] = 1,
				[general.title_gap.val] = true,
				[general.section_gap.val] = true,
				[general.section_underline.val] = "",
				[general.section_title_gap.val] = true,
				[general.item_gap.val] = false,
				[general.section_order.val] = {"params", "return_type"}
			},
			params = {
				[item.title.val] = " # Arguments",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = false,
				[item.type_first.val] = false,
				[item.kw.val] = "",
				[item.type_kw.val] = "",
				[item.name_wrapper.val] = {" * `", "`"},
				[item.type_wrapper.val] = {"", ""},
				[item.is_type_below_name_first.val] = false,
			},
			return_type = {
				[item.title.val] = " # Returns",
				[item.inline.val] = true,
				[item.indent.val] = false,
				[item.include_type.val] = false,
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
				[general.struct.val] = {"// "},
				[general.title_pos.val] = 1,
				[general.direction.val] = true
			}
		}
	}
}
