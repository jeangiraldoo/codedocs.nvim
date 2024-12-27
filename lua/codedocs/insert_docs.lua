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
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings used to configure a language's docstring style
-- @param filetype The name of the programming language that corresponds with the current filetype
local function start_docstring_insertion(settings, style)
	require("codedocs.lua.codedocs.style_validations").validate_style(settings, style)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line (1-based index)
	local line_content = vim.api.nvim_buf_get_lines(0, cursor_pos - 1, cursor_pos, false)[1]

	local docstring = require("codedocs.lua.codedocs.docs_builder").get_docstring(settings, style, line_content)
	local direction = style[settings.direction.val]

	local insert_pos = (direction) and cursor_pos - 1 or cursor_pos
	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, docstring)

	move_cursor_to_title(#docstring, direction, style[settings.title_pos.val])
end

--- Inserts a docstring for the function under the cursor
-- @param settings (table) Keys used to access setting values in a style
-- @param styles (table) A map of languages to docstring configurations
-- @param filetype (string) The name of the programming language used in the current file
local function insert_docs(settings, style, filetype)
	if style then
		start_docstring_insertion(settings, style)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	insert_docs = insert_docs
}
