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
	local filetype = vim.bo.filetype
	local lang_details = lang_templates[filetype]
	local docstring = lang_details["template"]
	if docstring then
		start_doc_insertion(lang_details, docstring)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	insert_docs = insert_documentation
}
