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
local function add_indent_to_docstring(docs, indent_string, direction)
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

--- Returns the wrapped parameter name and type, with their respective keywords prepended
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param param (table | string) Parameter found in the function declaration. A table if it has a type, a string otherwise
-- @return table
local function get_wrapped_param_data(settings, style, param)
	local is_type_first = style[settings.is_type_first.val]
	local name_wrapper = style[settings.name_wrapper.val]
	local type_wrapper = style[settings.type_wrapper.val]
	local param_keyword = style[settings.param_keyword.val]
	local type_keyword = style[settings.type_keyword.val]

	local name_pos, type_pos = (is_type_first) and 2 or 1, (is_type_first) and 1 or 2
	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name, wrapped_type
	if type(param) == "table" then
		wrapped_name = open_name_wrapper .. param[name_pos] .. close_name_wrapper
		wrapped_type = open_type_wrapper .. param[type_pos] .. close_type_wrapper
	else
		wrapped_name = open_name_wrapper .. param .. close_name_wrapper
		wrapped_type = open_type_wrapper .. close_type_wrapper
	end
	local is_param_one_line = style[settings.is_param_one_line.val]
	local final_name = param_keyword .. " " .. wrapped_name
	local simple_type = type_keyword .. " " .. wrapped_type
	local type_in_own_line = type_keyword .. " " .. wrapped_name .. " " .. wrapped_type
	local final_type = is_param_one_line and simple_type or type_in_own_line
	return {final_name, final_type}
end

--- Returns a parameter's data arranged either across a single line or 2
-- @param wrapped_param (table) Contains the parameter's name and type ready to be arranged
-- @param type_goes_first (boolean) Determines if the parameter's type goes before the name in the docstring
-- @param is_param_one_line (boolean) Determines if the parameter's name and type are arranged in 1 line or 2
local function get_arranged_param(wrapped_param, type_goes_first, is_param_one_line)
	local param_name = wrapped_param[1]
	local param_type = wrapped_param[2]

	local name_first, type_first
	if is_param_one_line then
		name_first = param_name .. param_type
		type_first = param_type .. param_name
	else
		name_first = {param_name, param_type}
		type_first = {param_type, param_name}
	end
	return (type_goes_first) and type_first or name_first
end

--- Inserts a section with content related to parameters into the docstring
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docs (table) The docstring base structure
local function add_section_params(settings, style, params, docs)
	local line_start = style[settings.struct.val][2]
	local param_indent = style[settings.param_indent.val]
	local base_line = (param_indent) and ("\t" .. line_start) or (line_start)
	local type_goes_first = style[settings.type_goes_first.val]
	local is_param_one_line = style[settings.is_param_one_line.val]

	for i = 1, #params do
		local param = params[i]
		local wrapped_param_data = get_wrapped_param_data(settings, style, param)
		local param_data = get_arranged_param(wrapped_param_data, type_goes_first, is_param_one_line)

		if type(param_data) == "string" then
			table.insert(docs, #docs, base_line .. param_data)
		elseif type(param_data) == "table" then
			for _, value in pairs(param_data) do
				table.insert(docs, #docs, base_line .. value)
			end
		end
	end
end

--- Adds a parameter section (title + parameters) to a docstring
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docs (table) The docstring base structure
local function insert_param_section(settings, style, params, docs)
	local title = style[settings.params_title.val]
	local title_underline_char = style[settings.section_underline.val]

	add_section_title(title_underline_char, title, docs)
	add_section_params(settings, style, params, docs)

	if #style[settings.struct.val] == 2 then table.remove(docs, #docs) end
end

--- Fills a docstring with a parameter section and an empty line (if applicable)
-- and inserts the parameters into the docstring
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_docstring(settings, style, params)
	local is_empty_line_after_title = style[settings.empty_line_after_title.val]
	local empty_line_pos = style[settings.title_pos.val] + 1
	local docs_copy = copy_docstring(style[settings.struct.val])
	local line_start = docs_copy[2]

	if is_empty_line_after_title then table.insert(docs_copy, empty_line_pos, line_start) end
	insert_param_section(settings, style, params, docs_copy)
	return docs_copy
end

--- Extracts function parameters as strings if no type is found, or as a table with name and type
---
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param line (string) Text on the line under the cursor containing the function signature
-- @return (table | nil) A table with parameters as elements, nil if no parameters are found
local function extract_function_params(settings, style, line)
	if line and not string.match(line, style[settings.func_keyword.val]) then
		return nil
	end

	local param_list = string.match(line, "%((.-)%)")
	local param_list_without_spaces = string.gsub(param_list, "%s+", "")
	local params = vim.split(param_list_without_spaces, ",")

	local separator = style[settings.param_type_separator.val]
	local params_info = {}
	local param_info
	for i = 1, #params do
		local param = params[i]
		if separator ~= "" and string.find(param, separator) then
			param_info = vim.split(param, separator)
		else
			param_info = param
		end
		table.insert(params_info, i, param_info)
	end
	return params_info
end

--- Returns a docstring with content or an empty one
-- If parameters are detected, returns a docstring with them; else, returns its base structure
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring style
-- @param line (string) The line under the cursor containing the function signature
-- @return (table) The updated docstring or the original one
local function get_docstring(settings, style, line)
	local docs_struct = style[settings.struct.val]
	local direction = style[settings.direction.val]
	local params = extract_function_params(settings, style, line)
	local line_indentation = line:match("^[^%w]*")

	local docs = (params) and generate_docstring(settings, style, params) or docs_struct
	return add_indent_to_docstring(docs, line_indentation, direction)
end

return {
	get_docstring = get_docstring
}
