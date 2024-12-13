local function insert_above(docstring)
	local current_line_pos = vim.fn.line(".") - 1
	vim.api.nvim_buf_set_lines(0, current_line_pos, current_line_pos, false, docstring)

	vim.cmd("normal! kk")
	vim.cmd("normal! $")
	vim.cmd('startinsert')
	vim.api.nvim_input('<Right>')
end

local function start_doc_insertion(lang_details, docstring)
	local docstring_pos = lang_details["pos"]
	if docstring_pos == "above" then
		insert_above(docstring)
	end
end

local function insert_documentation(lang_templates)
	local current_line = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line (1-based index)
	local line_content = vim.api.nvim_buf_get_lines(0, current_line -1, current_line, false)[1]
	local filetype = vim.bo.filetype
	local lang_details = lang_templates[filetype]
	local docstring = lang_details["template"]
	if docstring then
		start_doc_insertion(lang_details, docstring)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
	require("codedocs.lua.codedocs.parameter_parser").start_arg_insertion(line_content, lang_details)
end

return {
	insert_docs = insert_documentation
}
