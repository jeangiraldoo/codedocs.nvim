local opts = require("codedocs.specs.langs.style_opts")
local general = opts.general
local item = opts.item

local general_opts = {
	[general.struct.val] = { "/**", " * ", " */" },
	[general.direction.val] = true,
	[general.title_pos.val] = 2,
	[general.title_gap.val] = true,
	[general.section_gap.val] = false,
	[general.section_underline.val] = "",
	[general.section_title_gap.val] = false,
	[general.item_gap.val] = false,
	[general.section_order.val] = { "params", "return_type" },
}

local params_opts = {
	[item.title.val] = "",
	[item.inline.val] = true,
	[item.indent.val] = false,
	[item.include_type.val] = true,
	[item.type_first.val] = true,
	[item.name_kw.val] = "",
	[item.type_kw.val] = "@param",
	[item.name_wrapper.val] = { "", "" },
	[item.type_wrapper.val] = { "", "" },
	[item.is_type_below_name_first.val] = false,
}

local return_type_opts = {
	[item.title.val] = "",
	[item.inline.val] = true,
	[item.indent.val] = false,
	[item.include_type.val] = false,
	[item.type_first.val] = true,
	[item.name_kw.val] = "",
	[item.type_kw.val] = "@return",
	[item.name_wrapper.val] = { "", "" },
	[item.type_wrapper.val] = { "", "" },
	[item.is_type_below_name_first.val] = false,
}

return {
	general = general_opts,
	params = params_opts,
	return_type = return_type_opts,
}
