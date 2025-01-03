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

local function get_docs(opts, style)
	local ts_utils = require'nvim-treesitter.ts_utils'
	local docs_builder = require("codedocs.docs_builder.init")
	local valid_node = get_supported_node(ts_utils.get_node_at_cursor())
	local docs
	if valid_node == nil then
		docs = style[opts.struct.val]
	elseif is_node_a_function(valid_node:type()) then
		docs = docs_builder.func.get_docs(opts, style, valid_node, ts_utils)
	end
	return docs
end

--- Indents each line of a docstring by prepending an indentation string
-- @param docs (table) A list of strings representing the lines of the docstring
-- @param indent_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function add_indent_to_docs(docs, indent_string, direction)
	local direction_based_indent = (direction) and "" or "\t"
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

--- Inserts a docstring either above or below the function signature and moves the cursor where the title goes
-- @param opts (table) Keys used to access opt values in a style
-- @param style (table) Options used to configure a language's docstring style
-- @param filetype The name of the programming language that corresponds with the current filetype
local function insert_docs(opts, style)
	require("codedocs.style_validations").validate_style(opts, style)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)[1] -- Get the current cursor line (1-based index)
	local line_content = vim.api.nvim_buf_get_lines(0, cursor_pos - 1, cursor_pos, false)[1]
	local line_indentation = line_content:match("^[^%w]*")

	local docs = get_docs(opts, style)

	local direction = style[opts.direction.val]
	docs = add_indent_to_docs(docs, line_indentation, direction)

	local insert_pos = (direction) and cursor_pos - 1 or cursor_pos
	vim.api.nvim_buf_set_lines(0, insert_pos, insert_pos, false, docs)

	move_cursor_to_title(#docs, direction, style[opts.title_pos.val])
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
