local opts = require("codedocs.specs._langs.style_opts")

local general_opts = {
	[opts.struct.val] = { "// " },
	[opts.title_pos.val] = 1,
	[opts.direction.val] = true,
}

return {
	general = general_opts,
}
