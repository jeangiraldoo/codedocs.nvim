local opts = require("codedocs.docs_gen.styles.opts")
local general = opts.general

local general_opts = {
	[general.struct.val] = {"-- "},
	[general.title_pos.val] = 1,
	[general.direction.val] = true
}

return {
	general = general_opts
}
