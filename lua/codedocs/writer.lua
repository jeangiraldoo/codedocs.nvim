local function move_cursor_to_title(docs_data)
	local node_pos = docs_data.pos
	local title_pos = docs_data.title_pos
	local line_length = #vim.api.nvim_buf_get_lines(0, node_pos, node_pos + 1, false)[1]
	local new_pos = docs_data.direction and (node_pos + title_pos) or (node_pos + title_pos + 1)
	vim.api.nvim_win_set_cursor(0, { new_pos, line_length })
	vim.cmd("startinsert")
	vim.api.nvim_input("<Right>")
end

-- Function to convert tabs to spaces based on the tabstop value
local function convert_tabs_to_spaces(indentation, tabstop) return indentation:gsub("\t", string.rep(" ", tabstop)) end

--- Indents each line of a docstring by prepending an indentation string
-- @param docs (table) A list of strings representing the lines of the docstring
-- @param indent_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function add_indent_to_docs(docs, indent_string, tabstop, direction)
	local direction_based_indent = direction and "" or convert_tabs_to_spaces("\t", tabstop)
	local indented_lines = {}
	for _, line in pairs(docs) do
		for idx = 1, #indent_string do
			local char = string.sub(indent_string, idx, idx)
			line = char .. line
		end
		table.insert(indented_lines, direction_based_indent .. line)
	end
	return indented_lines
end

local function get_line_indentation(line_content, tabstop)
	local indentation = line_content:match("^%s*")
	return convert_tabs_to_spaces(indentation, tabstop)
end

local function write_to_buffer(docs, docs_data)
	local direction = docs_data.direction
	local pos = docs_data.pos
	local line_content = vim.api.nvim_buf_get_lines(0, pos, pos + 1, false)[1]

	local tabstop = vim.api.nvim_buf_get_option(0, "tabstop")
	local indent_spaces = get_line_indentation(line_content, tabstop)
	local indented_docs = add_indent_to_docs(docs, indent_spaces, tabstop, direction)
	local insert_pos = direction and pos or pos + 1

	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, { "" })
	vim.api.nvim_buf_set_text(0, insert_pos, 0, insert_pos, 0, indented_docs)
end

--- Inserts a docstring for the function under the cursor
-- @param opts (table) Keys used to access opt values in a style
-- @param styles (table) A map of languages to docstring configurations
-- @param filetype (string) The name of the programming language used in the current file
local function start(docs, docs_data)
	write_to_buffer(docs, docs_data)
	move_cursor_to_title(docs_data)
end

return {
	start = start,
}
