local opts = require("codedocs.specs._langs.style_opts")
-- local general = opts.general
-- local item = opts.item

local general_opts = {
	[opts.struct.val] = { '"""', "", '"""' },
	[opts.direction.val] = false,
	[opts.title_pos.val] = 2,
	[opts.title_gap.val] = true,
	[opts.section_gap.val] = false,
	[opts.section_underline.val] = "",
	[opts.section_title_gap.val] = false,
	[opts.item_gap.val] = false,
	[opts.section_order.val] = { "params", "return_type" },
}

local params_opts = {
	[opts.title.val] = "",
	[opts.inline.val] = false,
	[opts.indent.val] = false,
	[opts.include_type.val] = true,
	[opts.type_first.val] = false,
	[opts.name_kw.val] = ":param",
	[opts.type_kw.val] = ":type",
	[opts.name_wrapper.val] = { "", ":" },
	[opts.type_wrapper.val] = { "", "" },
	[opts.is_type_below_name_first.val] = true,
}

local return_type_opts = {
	[opts.title.val] = "",
	[opts.inline.val] = false,
	[opts.indent.val] = false,
	[opts.include_type.val] = true,
	[opts.type_first.val] = false,
	[opts.name_kw.val] = ":return:",
	[opts.type_kw.val] = ":rtype:",
	[opts.name_wrapper.val] = { "", "" },
	[opts.type_wrapper.val] = { "", "" },
	[opts.is_type_below_name_first.val] = true,
}

return {
	general = general_opts,
	params = params_opts,
	return_type = return_type_opts,
}
