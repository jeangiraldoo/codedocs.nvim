local Utils = {}
local Codedocs = require "codedocs"

---@param filetype string
---@param buffer_lines string[]
---@param cursor_pos { row: number, col: number }
function Utils.mock_buffer(filetype, buffer_lines, cursor_pos)
	vim.validate {
		filetype = { filetype, "string" },
		buffer_lines = { buffer_lines, "table" },
		cursor_pos = { cursor_pos, "table" },
		cursor_pos_row = { cursor_pos.row, "number" },
		cursor_pos_col = { cursor_pos.col, "number" },
	}

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

---Builds a list with the names of the targets a language supports
---@return string[] supported_target_names
function Utils.get_supported_targets(lang_name)
	local target_identifiers = require("codedocs").get_target_identifiers(lang_name)

	local values = vim.tbl_values(target_identifiers)
	table.sort(values)
	local supported_target_names = vim.fn.uniq(values)
	table.insert(supported_target_names, "comment")

	return supported_target_names
end

function Utils.for_style(func)
	for _, lang_name in ipairs(Codedocs.get_supported_langs()) do
		for _, style_name in ipairs(Codedocs.get_supported_styles(lang_name)) do
			func(lang_name, style_name)
		end
	end
end

return Utils
