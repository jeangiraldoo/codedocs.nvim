--- Creates a copy of a language's docstring structure
-- @param docs_struct (table) The original table representing the docstring structure
-- @return (table) A new table that is a copy of "docstring_struct"
local function copy_docstring(docs_struct)
	local copied_docs_struct = {}
	for i = 1, #docs_struct do
		local copied_elem = docs_struct[i]
		table.insert(copied_docs_struct, i, copied_elem)
	end
	return copied_docs_struct
end

--- Moves the cursor to the docstring title and enters insert mode for immediate typing
-- @param doc_len (number) Number of lines in the inserted docstring
-- @param direction (boolean) Direction of the docstring insertion. True for above, false for below
-- @param title_pos (number) Line offset of the title within the docstring structure
local function move_cursor_to_title(node_pos, direction, title_pos)
	local line_length = #vim.api.nvim_buf_get_lines(0, node_pos, node_pos + 1, false)[1]
	local new_pos = (direction) and (node_pos + title_pos) or (node_pos + title_pos + 1)
	vim.api.nvim_win_set_cursor(0, {new_pos, line_length})
	vim.cmd('startinsert')
	vim.api.nvim_input('<Right>')
end

-- Function to convert tabs to spaces based on the tabstop value
local function convert_tabs_to_spaces(indentation, tabstop)
    return indentation:gsub("\t", string.rep(" ", tabstop))
end

--- Indents each line of a docstring by prepending an indentation string
-- @param docs (table) A list of strings representing the lines of the docstring
-- @param indent_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function add_indent_to_docs(docs, indent_string, tabstop, direction)
	local direction_based_indent = (direction) and "" or convert_tabs_to_spaces("\t", tabstop)
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

local function insert_docs(opts, style)
	local filetype = vim.bo.filetype
	local builder = require("codedocs.builder").get_docs
	local parser = require("codedocs.node_parser.parser")

	local struct_name, node = parser.get_node_type(filetype)
	local docs_style = style[struct_name]
	local sections = docs_style.general.section_order
	local include_type = docs_style.general[opts.item.include_type.val]
	local pos, data = parser.get_data(filetype, node, sections, struct_name, include_type)
	local docs_copy = copy_docstring(docs_style.general[opts.general.struct.val])
	local docs = (struct_name == "generic") and docs_copy or builder(opts, docs_style, data, docs_copy)

	local line_content = vim.api.nvim_buf_get_lines(0, pos, pos + 1, false)[1]

	local direction = docs_style.general[opts.general.direction.val]
    local tabstop = vim.api.nvim_buf_get_option(0, "tabstop")
	local indent_spaces = get_line_indentation(line_content, tabstop)
	docs = add_indent_to_docs(docs, indent_spaces, tabstop, direction)
	local insert_pos = (direction) and pos or pos + 1

	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, {""})
	vim.api.nvim_buf_set_text(0, insert_pos, 0, insert_pos, 0, docs)
	move_cursor_to_title(pos, direction, docs_style.general[opts.general.title_pos.val])
end

--- Inserts a docstring for the function under the cursor
-- @param opts (table) Keys used to access opt values in a style
-- @param styles (table) A map of languages to docstring configurations
-- @param filetype (string) The name of the programming language used in the current file
local function start(opts, style, filetype)
	if style then
		insert_docs(opts, style)
	else
		print("There are no defined documentation strings for " .. filetype .. " files")
	end
end

return {
	start = start
}
