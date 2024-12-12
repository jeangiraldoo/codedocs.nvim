local defaults = require("codedocs.lua.codedocs.languages")
local insert_documentation = require("codedocs.lua.codedocs.insert_docs")

local M = {}

M.config = {
	default_templates = defaults
}

function M.setup()
    print("Codedocs has been set up!")
end

function M.insert_docs()
	insert_documentation.insert_docs(defaults)
end

vim.api.nvim_set_keymap('n', "<Plug>Codedocs", "<cmd>lua require('codedocs').insert_docs()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_user_command(
	"Codedocs",
	function()
		insert_documentation.insert_docs(defaults)
	end,
	{}
)

return M
