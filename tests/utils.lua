local Utils = {}

---@param filetype string
---@param buffer_lines string[]
---@param cursor_pos { row: number, col: number }
function Utils.mock_buffer(filetype, buffer_lines, cursor_pos)
	assert(type(filetype) == "string", "The filetype parameter must be a string, got " .. type(filetype))
	assert(type(buffer_lines) == "table", "The structure parameter must be a table, got " .. type(buffer_lines))

	assert(type(cursor_pos) == "table", "The cursor_pos parameter must be a table, got " .. type(cursor_pos))
	assert(type(cursor_pos.row) == "number", "The cursor_pos row must be a number, got " .. type(cursor_pos.row))
	assert(type(cursor_pos.col) == "number", "The cursor_pos col must be a number, got " .. type(cursor_pos.col))

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_set_current_buf(buf)
	vim.bo.filetype = filetype

	vim.api.nvim_buf_set_lines(0, 0, -1, false, buffer_lines)
	vim.api.nvim_win_set_cursor(0, { cursor_pos.row, cursor_pos.col })
	vim.bo.swapfile = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.bo.expandtab = false
end

---Builds a list with the names of the structures a language supports
---@return string[] supported_struct_names
function Utils.get_supported_structs(lang_name)
	local struct_identifiers = require("codedocs").get_struct_identifiers(lang_name)

	local values = vim.tbl_values(struct_identifiers)
	table.sort(values)
	local supported_struct_names = vim.fn.uniq(values)
	table.insert(supported_struct_names, "comment")

	return supported_struct_names
end

return Utils
