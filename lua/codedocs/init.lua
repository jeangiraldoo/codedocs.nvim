local M = {}
local docs_gen = require("codedocs.docs_gen.init")

function M.setup(config)
	local style_manager = docs_gen.style_manager
	if config and config.default_styles then
		style_manager.set_default_lang_style(config.default_styles)
	end
end

local function get_node_settings(style, opts, struct_name)
	local settings = {
		func = {},
		class = {boolean = (style.attrs) and style.attrs[opts.class_item.include_non_constructor_attrs.val]},
	}
	return settings[struct_name]
end

function M.insert_docs()
	local lang = vim.api.nvim_buf_get_option(0, "filetype")

	local builder = docs_gen.builder
	local parser = require("codedocs.node_parser.parser")

	local struct_name, node = parser.get_node_type(lang)
	local opts, style = builder.get_opts_and_style(lang, struct_name)
	local sections = style.general.section_order
	local include_type = style.general[opts.item.include_type.val]
	local parser_settings = get_node_settings(style, opts, struct_name)
	local pos, data = parser.get_data(lang, node, sections, struct_name, include_type, parser_settings)
	local struct = style.general[opts.general.struct.val]

	local docs = (struct_name == "generic") and struct or builder.get_docs(opts, style, data, struct)
	local docs_data = {
		pos = pos,
		direction = style.general[opts.general.direction.val],
		title_pos = style.general[opts.general.title_pos.val]
	}
	require("codedocs.writer").start(docs, docs_data)
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })
vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
