--- Moves the cursor to the docstring title's position and enters insert mode
-- Adjusts the cursor based on the docstring's placement relative to the function 
-- and positions it at the title location. Automatically starts insert mode for 
-- immediate typing.
-- @param docstring_length (number) Total number of lines in the inserted docstring
-- @param direction (string) Direction of the docstring insertion ("above" or "below" the function)
-- @param title_pos (number) Line offset of the title within the docstring structure
local function move_cursor_to_title(docstring_length, direction, title_pos)
	local current_line_pos = vim.api.nvim_win_get_cursor(0)[1] -- (1-based index)
	local line_length = #vim.api.nvim_buf_get_lines(0, current_line_pos - 1, current_line_pos, false)[1]
	local target_line_pos = current_line_pos - (docstring_length - title_pos) - 1 -- If direction is "above"

	if direction == "below" then
		target_line_pos = current_line_pos + title_pos
	end
	vim.api.nvim_win_set_cursor(0, {target_line_pos, line_length})
	vim.cmd('startinsert')
	vim.api.nvim_input('<Right>')
end

--- Inserts a documentation string into the buffer relative to a function declaration.
-- This function places the given "docstring" either above or below a function
-- declaration located at the specified "current_line_pos" in the buffer.
-- @param docstring (string) The string to be inserted into the buffer.
-- @param insertion_direction (string) Direction to insert the string relative to the function declaration.
-- @param current_line_pos (number) The 1-based line number where the cursor is located.
local function insert_into_buffer(docstring,  insertion_direction, current_line_pos)
	local insertion_line_pos = 0

	if insertion_direction == "above" then
		insertion_line_pos = current_line_pos - 1
	elseif insertion_direction == "below" then
		insertion_line_pos = current_line_pos
	end
	vim.api.nvim_buf_set_lines(0, insertion_line_pos, insertion_line_pos, false, docstring)
end

--- Inserts a documentation string for the function under the cursor.
-- Retrieves a docstring structure based on the current filetype, parses the function 
-- signature, and inserts the docstring into the buffer.
-- @param settings (table) Keys used to access setting values in a template
-- @param templates (table) A map of languages to docstring configurations
local function insert_documentation(settings, templates)
	local current_line_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line (1-based index)
	local line_content = vim.api.nvim_buf_get_lines(0, current_line_pos -1, current_line_pos, false)[1]
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local template = templates[filetype]
	if template then
		require("codedocs.lua.codedocs.template_validations").validate_template_integrity(settings, template, filetype)
		local docstring = require("codedocs.lua.codedocs.docstring_builder").get_docstring(settings, template, line_content)
		local direction = template[settings.direction.val]
		insert_into_buffer(docstring, direction, current_line_pos)
		move_cursor_to_title(#docstring, direction, template[settings.title_pos.val])
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	insert_docs = insert_documentation
}
