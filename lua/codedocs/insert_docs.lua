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

local function is_node_a_function(node_type)
	local identifiers = {
		function_definition = true,
		method_definition = true,
		function_declaration = true,
		method_declaration = true,
		method = true,
		function_item = true
	}

	return (identifiers[node_type]) and true or false
end

--- Traverses upwards through parent nodes to find a node of a supported type
-- @param node_at_cursor Node found at the cursor's position
-- @return A node of a supported type or nil
local function get_supported_node(node_at_cursor)
	if node_at_cursor == nil then
		return nil
	end

	if is_node_a_function(node_at_cursor:type()) then
		return node_at_cursor
  	end

  	-- Traverse upwards through parent nodes to find a function or method declaration
  	while node_at_cursor do
    	if is_node_a_function(node_at_cursor:type()) then
      		return node_at_cursor
    	end

    -- If it's a module or another node, continue traversing upwards
    	node_at_cursor = node_at_cursor:parent()
  	end

  	-- If no function or method node is found, return nil
  	return nil
end

local function get_docs_settings(opts, style, node)
	local docs_style, docs_opts, struct_name
	if node == nil then
		docs_style = style["generic"]
	docs_opts = opts["generic"]
		struct_name = "generic"
	elseif is_node_a_function(node:type()) then
		docs_style = style["func"]
		docs_opts = opts["func"]
		struct_name = "func"
	end
	return {docs_opts, docs_style, struct_name}
end

local function get_docs(opts, style, valid_node, ts_utils)
	local docs_builder = require("codedocs.docs_builder.init")
	local docs_copy = copy_docstring(style[opts.struct.val])
	local docs
	if valid_node == nil then
		docs = style[opts.struct.val]
	elseif is_node_a_function(valid_node:type()) then
		docs = docs_builder.func.get_docs(opts, style, valid_node, ts_utils, docs_copy)
	end
	return docs
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
    local indentation = line_content:match("^[^%w]*")
    return convert_tabs_to_spaces(indentation, tabstop)
end

local function insert_docs(opts, style)
	local ts_utils = require'nvim-treesitter.ts_utils'
	local valid_node = get_supported_node(ts_utils.get_node_at_cursor())
	local docs_settings = get_docs_settings(opts, style, valid_node)
	local docs_opts, docs_style, struct_name = docs_settings[1], docs_settings[2], docs_settings[3]
	require("codedocs.style_validations").validate_style(docs_opts, docs_style, struct_name)
	local docs = get_docs(docs_opts, docs_style, valid_node, ts_utils)

	local node_pos
	if valid_node == nil then
		node_pos = vim.api.nvim_win_get_cursor(0)[1] - 1
	else
		node_pos = valid_node:range()
	end

	local line_content = vim.api.nvim_buf_get_lines(0, node_pos, node_pos + 1, false)[1]

	local direction = docs_style[docs_opts.direction.val]
    local tabstop = vim.api.nvim_buf_get_option(0, "tabstop")
	local indent_spaces = get_line_indentation(line_content, tabstop)
	docs = add_indent_to_docs(docs, indent_spaces, tabstop, direction)
	local insert_pos = (direction) and node_pos or node_pos + 1
	vim.api.nvim_buf_set_text(0, insert_pos, 0, insert_pos, 0, {"", ""})
	vim.api.nvim_buf_set_text(0, insert_pos, 0, insert_pos, 0, docs)
	move_cursor_to_title(node_pos, direction, docs_style[docs_opts.title_pos.val])
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
