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
	"<cmd>lua require('codedocs').generate()<CR>",
	{ noremap = true, silent = true }
)
local function get_annotation_list()
	local lang = vim.bo.filetype
	local lang_stuff = require("codedocs.config").languages[lang]
	local substyles = vim.tbl_keys(lang_stuff.styles.definitions[lang_stuff.styles.default])
	print(vim.inspect(substyles))
	return substyles
end

vim.api.nvim_create_user_command("Codedocs", function(opts)
	local choice = opts.fargs[1]
	if choice and not vim.tbl_contains(get_annotation_list(), choice) then
		vim.notify("Invalid option: " .. (choice or "nil"), vim.log.levels.ERROR)
		return
	end
	require("codedocs").generate(choice)
end, {
	nargs = "?",
	complete = function(arglead)
		print(vim.inspect(get_annotation_list()))
		return vim.tbl_filter(function(opt) return opt:find(arglead) == 1 end, get_annotation_list())
	end,
})
