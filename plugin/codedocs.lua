local curr_file_path = debug.getinfo(1, "S").source
if curr_file_path:sub(1, 1) == "@" then curr_file_path = curr_file_path:sub(2) end

local plugin_dir = vim.fn.fnamemodify(curr_file_path, ":p:h")

-- Load help tags
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local doc_dir = vim.fn.fnamemodify(plugin_dir .. "/../doc", ":p")
		if vim.fn.isdirectory(doc_dir) == 1 then
			local load_help_tag_cmd = "helptags " .. vim.fn.fnameescape(doc_dir)
			vim.cmd(load_help_tag_cmd)
		end
	end,
})

vim.api.nvim_set_keymap(
	"n",
	"<Plug>Codedocs",
	"<cmd>lua require('codedocs').insert_docs()<CR>",
	{ noremap = true, silent = true }
)
vim.api.nvim_create_user_command("Codedocs", require("codedocs").insert_docs, {})
