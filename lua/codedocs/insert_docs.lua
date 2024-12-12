local function insert_above(template_lines)
	local current_line = vim.fn.line(".") - 1
	vim.api.nvim_buf_set_lines(0, current_line, current_line, false, template_lines)
	vim.cmd("normal! kk")
	vim.cmd("normal! $")
	vim.cmd('startinsert')
	vim.api.nvim_input('<Right>')
end

local function start_doc_insertion(lang_details, chosen_docstring)
	local template_lines = vim.split(chosen_docstring, '\n')
	local docstring_pos = lang_details["pos"]
	if docstring_pos == "above" then
		insert_above(template_lines)
	end
end

local function insert_documentation(lang_templates)
	local filetype = vim.bo.filetype
	local lang_details = lang_templates[filetype]
	local lang_docstring = lang_details["template"]
	if lang_docstring then
		start_doc_insertion(lang_details, lang_docstring)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	insert_docs = insert_documentation
}
