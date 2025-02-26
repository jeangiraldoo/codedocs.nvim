local opts = require("codedocs.specs.langs.style_opts")
-- local general = opts.general
-- local opts = opts.item
-- local opts = opts.class_general

local general_opts = {
	[opts.struct.val] = { '"""', "", '"""' },
	[opts.direction.val] = false,
	[opts.title_pos.val] = 2,
	[opts.title_gap.val] = true,
	[opts.section_gap.val] = false,
	[opts.section_underline.val] = "",
	[opts.section_title_gap.val] = false,
	[opts.item_gap.val] = false,
	[opts.section_order.val] = { "attrs" },
	[opts.include_class_body_attrs.val] = true,
	[opts.include_instance_attrs.val] = true,
	[opts.include_only_constructor_instance_attrs.val] = true,
}

local attrs_opts = {
	[opts.title.val] = "Attributes:",
	[opts.inline.val] = true,
	[opts.indent.val] = true,
	[opts.include_type.val] = true,
	[opts.type_first.val] = false,
	[opts.name_kw.val] = "",
	[opts.type_kw.val] = "",
	[opts.name_wrapper.val] = { "", "" },
	[opts.type_wrapper.val] = { "(", "):" },
	[opts.is_type_below_name_first.val] = false,
}

return {
	general = general_opts,
	attrs = attrs_opts,
}
