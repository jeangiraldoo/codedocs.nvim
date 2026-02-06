---TODO: Possible improvement, annotation_base_row + title_relative_row could be abstracted away at the caller
local function move_cursor_to_title(annotation_base_row, title_relative_row, insert_above)
	assert(type(insert_above) == "boolean", "'insert_above' must be a boolean, got " .. type(insert_above))

	assert(
		type(annotation_base_row) == "number",
		"'annotation_base_row' must be a number, got " .. type(annotation_base_row)
	)
	assert(annotation_base_row >= 0, "'annotation_base_row' must be 0 or higher, got " .. annotation_base_row)

	assert(
		type(title_relative_row) == "number",
		"'title_relative_row' must be a number, got " .. type(title_relative_row)
	)
	assert(title_relative_row >= 0, "'title_relative_row' must be 0 or higher, got " .. title_relative_row)

	local title_row = annotation_base_row + title_relative_row
	local target_row = insert_above and title_row or (title_row + 1)

	vim.api.nvim_win_set_cursor(0, { target_row, 0 })
	vim.cmd("normal! $")
	vim.cmd("startinsert!")
end

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

local function add_indent_to_docs(annotation, base_indent, insert_above)
	assert(type(annotation) == "table", "'annotation' must be a table, got " .. type(annotation))
	assert(type(base_indent) == "string", "'base_indent' must be a string, got " .. type(base_indent))
	assert(type(insert_above) == "boolean", "'insert_above' must be a boolean, got " .. type(insert_above))

	local extra_indent
	if insert_above then
		extra_indent = ""
	else -- Languages where annotations appear below the structure definition require an extra indentation level
		if vim.bo.expandtab then
			local shiftwidth = vim.bo.shiftwidth
			if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end
			extra_indent = string.rep(" ", shiftwidth)
		else
			extra_indent = "\t"
		end
	end

	local prefix = base_indent .. extra_indent

	local indented_lines = {}
	for i, annotation_line in ipairs(annotation) do
		indented_lines[i] = prefix .. annotation_line
	end

	return indented_lines
end

-- Inserts an annotation relative to a structure and moves the cursor to the annotation title.
--
-- The annotation is indented to match the structure. If the annotation is inserted
-- below the structure, it is indented one additional level as required by languages
-- that expect nested annotations.
--
-- @param annotation string[] Lines that make up the annotation to insert
-- @param row integer 0-based row where the structure starts
-- @param insert_above boolean If true, insert above the structure; otherwise below
-- @param title_pos integer Row offset of the title line within the annotation
return function(annotation, row, insert_above, title_pos)
	assert(type(annotation) == "table", "'annotation' must be a string, got " .. type(annotation))
	assert(type(insert_above) == "boolean", "'insert_above' must be a boolean, got " .. type(insert_above))

	assert(type(row) == "number", "'row' must be a number, got " .. type(row))
	assert(row >= 0, "'row' must be 0 or higher, got " .. row)

	local structure_indent_string = compute_line_indent(row + 1)
	local indented_docs = add_indent_to_docs(annotation, structure_indent_string, insert_above)

	local insert_pos = insert_above and row or row + 1

	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, indented_docs)
	move_cursor_to_title(row, title_pos, insert_above)
end
