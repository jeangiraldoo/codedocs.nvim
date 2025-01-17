local defaults = require("codedocs.styles.init")
local insert_docs = require("codedocs.insert_docs")

local M = {}

M.config = {
	opts = defaults[1],
	default_styles = defaults[2],
	lang_styles = defaults[3]
}

function M.setup(config)
	if config and config.default_styles then
		for key, value in pairs(config.default_styles) do
			if not M.config.default_styles[key] then
				error("There is no language called " .. key .. " available in codedocs")
			elseif type(value) ~= "string" then
				error("The value assigned as the default docstring style for " .. key .. " must be a string")
			elseif not M.config.lang_styles[key][value] then
				error(key .. " does not have a docstring style called " .. value)
			end
			M.config.default_styles[key] = value
		end
	end
end

function M.insert_docs()
	-- if not pcall(require, "nvim-treesitter.configs") then
	--  		vim.notify("Treesitter is not installed. Please install it.", vim.log.levels.ERROR)
	--  		return
	-- end
	-- local parsers = require "nvim-treesitter.parsers"
	local lang = vim.api.nvim_buf_get_option(0, "filetype")

	local default_lang_style = M.config.default_styles[lang]
	local lang_styles = M.config.lang_styles[lang]
	if not default_lang_style or not lang_styles then
		error("There is no language called " .. lang .. " available in Codedocs")
	end
	-- if not parsers.has_parser(lang) then
	--    	vim.notify("The treesitter parser for " .. lang .. " is not installed")
	--    	return true
	-- end
	local lang_style = lang_styles[default_lang_style]
	insert_docs.start(M.config.opts, lang_style, lang)
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("Codedocs", M.insert_docs, {})

return M
