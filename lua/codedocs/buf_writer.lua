local function compute_line_indent(line_row)
	assert(type(line_row) == "number", "'line_row' must be a number, got " .. type(line_row))
	assert(line_row >= 0, "'line_row' must be 0 or higher, got " .. line_row)

	local cols = vim.fn.indent(line_row)

	if vim.bo.expandtab then return string.rep(" ", cols) end

	local tabstop = vim.bo.tabstop
	local tabs = math.floor(cols / tabstop)
	local spaces = cols % tabstop

	return string.rep("\t", tabs) .. string.rep(" ", spaces)
end

local function add_indent_to_docs()
	local extra_indent
	if vim.bo.expandtab then
		local shiftwidth = vim.bo.shiftwidth
		if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end
		extra_indent = string.rep(" ", shiftwidth)
	else
		extra_indent = "\t"
	end

	return extra_indent
end

--- Inserts an annotation relative to a structure and moves the cursor to the annotation title
---@param annotation_lines string[]
---@param positions { annotation_row: number, title_offset: number} 0-based annotation-related positions
---@param should_indent_annotation boolean
return function(annotation_lines, positions, should_indent_annotation)
	assert(type(annotation_lines) == "table", "'annotation' must be a string, got " .. type(annotation_lines))
	assert(
		type(should_indent_annotation) == "boolean",
		"'insert_above' must be a boolean, got " .. type(should_indent_annotation)
	)

	assert(type(positions) == "table", "'positions' must be a table, got " .. type(positions))
	assert(
		type(positions.annotation_row) == "number",
		"'annotation_row' must be a number, got " .. type(positions.annotation_row)
	)
	assert(positions.annotation_row >= 0, "'annotation_row' must be 0 or higher, got " .. positions.annotation_row)
	assert(
		type(positions.title_offset) == "number",
		"'title_offset' must be a number, got " .. type(positions.title_offset)
	)
	assert(positions.title_offset >= 0, "'title_offset' must be 0 or higher, got " .. positions.title_offset)

	local structure_indent_string = compute_line_indent(positions.annotation_row + 1)
	if should_indent_annotation then structure_indent_string = structure_indent_string .. add_indent_to_docs() end

	local indented_lines = {}
	for i, annotation_line in ipairs(annotation_lines) do
		indented_lines[i] = structure_indent_string .. annotation_line
	end

	if vim.api.nvim_get_current_line() ~= "" then
		vim.api.nvim_buf_set_lines(
			0,
			positions.annotation_row > 0 and positions.annotation_row or 0,
			positions.annotation_row > 0 and positions.annotation_row or 0,
			false,
			{ "" }
		)
	end
	vim.api.nvim_win_set_cursor(0, { positions.annotation_row + 1, 0 })
	vim.snippet.expand(table.concat(indented_lines, "\n"))
end
