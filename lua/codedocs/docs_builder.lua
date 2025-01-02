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

--- Inserts a section title and an underline (if applicable)
-- @param underline_char Character to create a string from
-- @param title The title of the section
-- @param docs Docstring to insert the section title into
local function add_section_title(underline_char, title, docs)
	if title ~= "" then table.insert(docs, #docs, title) end

	if underline_char ~= "" then
		table.insert(docs, #docs, string.rep(underline_char, #title))
	end
end

--- Wraps the parameter's name and type
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param param (table | string) Parameter found in the function declaration. A table if it has a type, a string otherwise
-- @return table
local function get_wrapped_param_info(opts, style, param)
	local name_wrapper = style[opts.name_wrapper.val]
	local type_wrapper = style[opts.type_wrapper.val]

	local param_name = param.name
	local param_type = (param.type) and param.type or ""

	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name = open_name_wrapper .. param_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. param_type .. close_type_wrapper
	return {wrapped_name, wrapped_type}
end

--- Returns a parameter's data arranged either across a single line or 2
-- @param wrapped_param (table) Contains the parameter's name and type ready to be arranged
-- @param type_goes_first (boolean) Determines if the parameter's type goes before the name in the docstring
-- @param is_param_one_line (boolean) Determines if the parameter's name and type are arranged in 1 line or 2
local function get_arranged_param_info(opts, style, wrapped_param, type_goes_first, is_param_one_line)
	local param_name = wrapped_param[1]
	local param_type = wrapped_param[2]
	local type_keyword = style[opts.type_keyword.val]
	local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	local final_name = style[opts.param_keyword.val] .. " " .. param_name
	local final_type, name_first, type_first
	if is_param_one_line then
		final_type = type_keyword .. " " .. param_type
		name_first = final_name .. final_type
		type_first = final_type .. final_name
	else
		local standalone_type = type_keyword .. " " .. param_type
		local type_with_name = type_keyword .. " " .. param_name .. " " .. param_type
		final_type = (is_type_below_name_first) and type_with_name or standalone_type
		name_first = {final_name, final_type}
		type_first = {final_type, final_name}
	end
	return (type_goes_first) and type_first or name_first
end

--- Inserts a section with content related to parameters into the docstring
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docs (table) The docstring base structure
local function add_section_params(opts, style, params, docs)
	local line_start = style[opts.struct.val][2]
	local base_line = (style[opts.param_indent.val]) and ("\t" .. line_start) or (line_start)
	local type_goes_first = style[opts.type_goes_first.val]
	local is_param_one_line = style[opts.is_param_one_line.val]

	for i = 1, #params do
		local param = params[i]
		local wrapped_info = get_wrapped_param_info(opts, style, param)
		local final_info = get_arranged_param_info(opts, style, wrapped_info, type_goes_first, is_param_one_line)

		if type(final_info) == "string" then
			table.insert(docs, #docs, base_line .. final_info)
		elseif type(final_info) == "table" then
			for _, value in pairs(final_info) do
				table.insert(docs, #docs, base_line .. value)
			end
		end
	end
end

--- Adds a parameter section, composed of a title and parameters, to a docstring
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docs (table) The docstring base structure
local function insert_param_section(opts, style, params, title_underline_char, docs)
	local title = style[opts.params_title.val]
	-- local title_underline_char = style[opts.section_underline.val]

	add_section_title(title_underline_char, title, docs)
	add_section_params(opts, style, params, docs)

end

local function insert_return_section(opts, style, return_type, title_underline_char, docs)
	local title = style[opts.return_title.val]
	add_section_title(title_underline_char, title, docs)
	local line_start = style[opts.struct.val][2]

	local is_return_one_line = style[opts.is_param_one_line.val]
	local return_keyword = style[opts.return_keyword.val]
	local return_type_keyword = style[opts.return_type_keyword.val]
	local type_wrapper = style[opts.return_type_wrapper.val]
	local is_type_in_docs = style[opts.is_return_type_in_docs.val]
	local wrapped_type = (is_type_in_docs) and type_wrapper[1] .. return_type .. type_wrapper[2] or type_wrapper

	local is_return_line_present = true
	local is_return_indented = style[opts.param_indent.val]
	local indent = (is_return_indented) and "\t" or ""

	local return_line
	if (not is_type_in_docs and return_keyword == "") or (return_keyword == "" and return_type == "unknown") then
		is_return_line_present = false
	elseif return_keyword == "" and (is_type_in_docs and return_type ~= "unknown") then
		return_line = (is_return_one_line) and indent .. line_start .. wrapped_type or {indent .. line_start .. return_keyword, indent .. return_type_keyword .. return_type}
	elseif return_keyword ~= "" and (not is_type_in_docs or return_type == "unknown") then
		return_line = (is_return_one_line) and indent .. line_start .. return_keyword or {indent .. line_start .. return_keyword, indent ..return_type_keyword .. ""}
	else
		return_line = (is_return_one_line) and indent .. line_start .. return_keyword .. " " .. wrapped_type or {indent .. line_start .. return_keyword, indent .. return_type_keyword .. " " .. return_type}
	end
	if is_return_line_present and type(return_line) == "string" then
		table.insert(docs, #docs, return_line)
	elseif is_return_line_present and type(return_line) == "table" then
		for _, value in pairs(return_line) do
			table.insert(docs, #docs, value)
		end

	end
end

--- Inserts a parameter section into the docstring and an empty line (if applicable)
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_function_docs(opts, style, params, return_type)
	local docs_copy = copy_docstring(style[opts.struct.val])
	local is_empty_line_after_title = style[opts.empty_line_after_title.val]
	local title_underline_char = style[opts.section_underline.val]

	if is_empty_line_after_title then
		local empty_line_pos = style[opts.title_pos.val] + 1
		local line_start = docs_copy[2]
		table.insert(docs_copy, empty_line_pos, line_start)
	end
	insert_param_section(opts, style, params, title_underline_char, docs_copy)
	if return_type ~= nil then
		insert_return_section(opts, style, return_type, title_underline_char, docs_copy)
	end
	if #style[opts.struct.val] == 2 then table.remove(docs_copy, #docs_copy) end
	return docs_copy
end

local function insert_function_docs(opts, style, node, ts_utils)
	local is_type_in_docs = style[opts.is_type_in_docs.val]
	local struct_parser = require("codedocs.struct_parser")
	local params = struct_parser.extract_func_params(node, ts_utils, is_type_in_docs)
	local return_type = struct_parser.get_func_return_type(ts_utils, node)
	return generate_function_docs(opts, style, params, return_type)
end

local function is_node_a_function(node_type)
local identifiers = {
		function_definition = true,
		method_definition = true,
		function_declaration = true,
		method_declaration = true,
		method = true
	}

	return (identifiers[node_type]) and true or false
end

local function get_docs_type(node_at_cursor)
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

--- Returns a docstring with content or an empty one
-- If parameters are detected, returns a docstring with them; else, returns its base structure
-- @param opts (table) Keys used to access opt values in a style
-- @param style (table) Options to configure the language's docstring style
-- @param line (string) The line under the cursor containing the function signature
-- @return (table) The updated docstring or the original one
local function get_docstring(opts, style, line)
	local ts_utils = require'nvim-treesitter.ts_utils'
	local node = ts_utils.get_node_at_cursor()

	local docs_struct = style[opts.struct.val]
	local direction = style[opts.direction.val]
	local docs_type = get_docs_type(node)
	local line_indentation = line:match("^[^%w]*")

	local docs
	if docs_type == nil then
		docs = docs_struct
	elseif is_node_a_function(docs_type:type()) then
		docs = insert_function_docs(opts, style, docs_type, ts_utils)
	end

	return add_indent_to_docs(docs, line_indentation, direction)
end

return {
	get_docstring = get_docstring
}
