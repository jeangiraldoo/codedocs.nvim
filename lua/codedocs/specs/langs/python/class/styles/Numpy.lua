local opts = require("codedocs.specs.langs.style_opts")
local general = opts.general
local item = opts.item
local class_general = opts.class_general

local general_opts = {
	[general.struct.val] = { '"""', "", '"""' },
	[general.direction.val] = false,
	[general.title_pos.val] = 2,
	[general.title_gap.val] = true,
	[general.section_gap.val] = false,
	[general.section_underline.val] = "_",
	[general.section_title_gap.val] = false,
	[general.item_gap.val] = false,
	[general.section_order.val] = { "attrs" },
	[class_general.include_class_body_attrs.val] = true,
	[class_general.include_instance_attrs.val] = true,
	[class_general.include_only_constructor_instance_attrs.val] = true,
}

local attrs_opts = {
	[item.title.val] = "Attributes:",
	[item.inline.val] = true,
	[item.indent.val] = false,
	[item.include_type.val] = true,
	[item.type_first.val] = false,
	[item.name_kw.val] = "",
	[item.type_kw.val] = "",
	[item.name_wrapper.val] = { "", "" },
	[item.type_wrapper.val] = { "", ":" },
	[item.is_type_below_name_first.val] = false,
}

return {
	general = general_opts,
	attrs = attrs_opts,
}
