local opts = require("codedocs.docs_gen.styles.opts")
local general = opts.general
local class_general = opts.class_general
local class_item = opts.class_item
local item = opts.item

local general_opts = {
	[general.struct.val] = {"/**", " * ", " */"},
	[general.direction.val] = true,
	[general.title_pos.val] = 2,
	[general.title_gap.val] = true,
	[general.section_gap.val] = false,
	[general.section_underline.val] = "",
	[general.section_title_gap.val] = false,
	[general.item_gap.val] = false,
	[general.section_order.val] = {"attrs"},
	[class_general.include_attrs.val] = false,
}

local attrs_opts = {
	[item.title.val] = "Attributes:",
	[item.inline.val] = true,
	[item.indent.val] = false,
	[item.include_type.val] = false,
	[item.type_first.val] = false,
	[item.kw.val] = "",
	[item.type_kw.val] = "",
	[item.name_wrapper.val] = {"- ", ": "},
	[item.type_wrapper.val] = {"", ""},
	[item.is_type_below_name_first.val] = false,
	[class_item.include_non_constructor_attrs.val] = false,
}

return {
	general = general_opts,
	attrs = attrs_opts
}
