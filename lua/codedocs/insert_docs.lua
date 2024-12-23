--- Moves the cursor to the docstring title and enters insert mode for immediate typing
-- @param doc_len (number) Number of lines in the inserted docstring
-- @param direction (boolean) Direction of the docstring insertion. True for above, false for below
-- @param title_pos (number) Line offset of the title within the docstring structure
local function move_cursor_to_title(doc_len, direction, title_pos)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- (1-based index)
	local line_length = #vim.api.nvim_buf_get_lines(0, cursor_pos - 1, cursor_pos, false)[1]
	local new_pos = (direction) and (cursor_pos - doc_len + title_pos - 1) or (cursor_pos + title_pos)
	vim.api.nvim_win_set_cursor(0, {new_pos, line_length})
	vim.cmd('startinsert')
	vim.api.nvim_input('<Right>')
end

--- Inserts a docstring either above or below the function signature and moves the cursor where the title goes
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings used to configure a language's docstring
-- @param filetype The name of the programming language that corresponds with the current filetype
local function start_docstring_insertion(settings, template, filetype)
	require("codedocs.lua.codedocs.template_validations").validate_template(settings, template)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line (1-based index)
	local line_content = vim.api.nvim_buf_get_lines(0, cursor_pos - 1, cursor_pos, false)[1]

	local docstring = require("codedocs.lua.codedocs.docstring_builder").get_docstring(settings, template, line_content)
	local direction = template[settings.direction.val]

	local insert_pos = (direction) and cursor_pos - 1 or cursor_pos
	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, docstring)

	move_cursor_to_title(#docstring, direction, template[settings.title_pos.val])
end

--- Inserts a documentation string for the function under the cursor.
-- Retrieves a docstring structure based on the current filetype, parses the function 
-- signature, and inserts the docstring into the buffer.
-- @param settings (table) Keys used to access setting values in a template
-- @param templates (table) A map of languages to docstring configurations
local function insert_documentation(settings, templates)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local template = templates[filetype]
	if template then
		start_docstring_insertion(settings, template, filetype)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	insert_docs = insert_documentation
}
