local defaults = require("codedocs.lua.codedocs.languages")
local insert_documentation = require("codedocs.lua.codedocs.insert_docs")

local M = {}

M.config = {
	settings = defaults[1],
	default_lang_styles = defaults[2],
	lang_styles = defaults[3]
}

function M.setup(config)
	if config and config.default_lang_styles then
		for key, value in pairs(config.default_lang_styles) do
			if not M.config.default_lang_styles[key] then
				error("There is no language called " .. key .. " available in codedocs")
			elseif type(value) ~= "string" then
				error("The value assigned as the default docstring style for " .. key .. " must be a string")
			elseif not M.config.lang_styles[key][value] then
				error(key .. " does not have a docstring style called " .. value)
			end
			M.config.default_lang_styles[key] = value
		end
	end
end

function M.insert_docs()
	local lang = vim.api.nvim_buf_get_option(0, "filetype")
	local default_lang_style = M.config.default_lang_styles[lang]
	local lang_styles = M.config.lang_styles[lang]
	if not default_lang_style or not lang_styles then
		error("There is no language called " .. lang .. " available in Codedocs")
	end
	local lang_style = lang_styles[default_lang_style]
	insert_documentation.insert_docs(M.config.settings, lang_style, lang)
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
