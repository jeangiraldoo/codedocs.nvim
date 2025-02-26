local opts = require("codedocs.specs.langs.style_opts")
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
	[opts.title.val] = "Args:",
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

local return_type_opts = {
	[opts.title.val] = "Returns:",
	[opts.inline.val] = true,
	[opts.indent.val] = true,
	[opts.include_type.val] = true,
	[opts.type_first.val] = false,
	[opts.name_kw.val] = "",
	[opts.type_kw.val] = "",
	[opts.name_wrapper.val] = { "", "" },
	[opts.type_wrapper.val] = { "", ":" },
	[opts.is_type_below_name_first.val] = false,
}

return {
	general = general_opts,
	params = params_opts,
	return_type = return_type_opts,
}
