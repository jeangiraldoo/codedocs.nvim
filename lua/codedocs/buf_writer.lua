--- Inserts an annotation relative to a structure and moves the cursor to the annotation title
---@param annotation_lines string[]
---@param positions { target: number, title_offset: number} 0-based annotation-related positions
---@param relative_position "above" | "below" | "empty_target_or_above" Position relative to the target row
return function(annotation_lines, positions, relative_position)
	assert(type(annotation_lines) == "table", "'annotation' must be a string, got " .. type(annotation_lines))
	assert(type(relative_position) == "string", "'relative_position' must be a string, got " .. type(relative_position))

	assert(type(positions) == "table", "'positions' must be a table, got " .. type(positions))
	assert(type(positions.target) == "number", "'annotation_row' must be a number, got " .. type(positions.target))
	assert(positions.target >= 0, "'annotation_row' must be 0 or higher, got " .. positions.target)
	assert(
		type(positions.title_offset) == "number",
		"'title_offset' must be a number, got " .. type(positions.title_offset)
	)
	assert(positions.title_offset >= 0, "'title_offset' must be 0 or higher, got " .. positions.title_offset)

	local final_target_pos
	if relative_position == "above" then
		final_target_pos = positions.target
	elseif relative_position == "below" then
		final_target_pos = positions.target + 1
	else
		final_target_pos = positions.target
	end

	if relative_position == "empty_target_or_above" and vim.api.nvim_get_current_line() ~= "" then
		vim.api.nvim_buf_set_lines(
			0,
			final_target_pos > 0 and final_target_pos or 0,
			final_target_pos > 0 and final_target_pos or 0,
			false,
			{ "" }
		)
	elseif relative_position == "above" or relative_position == "below" then
		vim.api.nvim_buf_set_lines(
			0,
			final_target_pos > 0 and final_target_pos or 0,
			final_target_pos > 0 and final_target_pos or 0,
			false,
			{ "" }
		)
	end

	vim.api.nvim_win_set_cursor(0, { final_target_pos + 1, 0 })
	local lines = table.concat(annotation_lines, "\n")
	vim.snippet.expand(lines)
end
