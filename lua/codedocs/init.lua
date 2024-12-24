local defaults = require("codedocs.lua.codedocs.languages")
local insert_documentation = require("codedocs.lua.codedocs.insert_docs")

local M = {}

M.config = {
	settings = defaults[1],
	default_lang_styles = defaults[2],
	lang_templates = defaults[3]
}

function M.setup()
    print("Codedocs has been set up!")
end

function M.insert_docs()
	local langs = vim.api.nvim_buf_get_option(0, "filetype")
	local default_lang_style = M.config.default_lang_styles[langs]
	local template = M.config.lang_templates[langs]
	local template_style = template[default_lang_style]
	insert_documentation.insert_docs(M.config.settings, template_style, langs)
end

function M.set_default_style(lang, style_name)
	local chosen_lang_styles = M.config.lang_templates[lang]
	if not chosen_lang_styles then
		error("There is no language called " .. lang .. " available in codedocs")
	end
	local new_default_style = chosen_lang_styles[style_name]
	if not new_default_style then
		error("There is no style for " .. lang .. " called " .. style_name)
	end
	M.config.default_lang_styles[lang] = style_name
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
