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
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param param (table | string) Parameter found in the function declaration. A table if it has a type, a string otherwise
-- @return table
local function get_wrapped_param_info(settings, style, param)
	local name_wrapper = style[settings.name_wrapper.val]
	local type_wrapper = style[settings.type_wrapper.val]
	local is_type_first = style[settings.is_type_first.val]

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
	return {wrapped_name, wrapped_type}
end

--- Returns a parameter's data arranged either across a single line or 2
-- @param wrapped_param (table) Contains the parameter's name and type ready to be arranged
-- @param type_goes_first (boolean) Determines if the parameter's type goes before the name in the docstring
-- @param is_param_one_line (boolean) Determines if the parameter's name and type are arranged in 1 line or 2
local function get_arranged_param_info(settings, style, wrapped_param, type_goes_first, is_param_one_line)
	local param_name = wrapped_param[1]
	local param_type = wrapped_param[2]
	local type_keyword = style[settings.type_keyword.val]
	local is_type_below_name_first = style[settings.is_type_below_name_first.val]

	local final_name = style[settings.param_keyword.val] .. " " .. param_name
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
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docs (table) The docstring base structure
local function add_section_params(settings, style, params, docs)
	local line_start = style[settings.struct.val][2]
	local base_line = (style[settings.param_indent.val]) and ("\t" .. line_start) or (line_start)
	local type_goes_first = style[settings.type_goes_first.val]
	local is_param_one_line = style[settings.is_param_one_line.val]

	for i = 1, #params do
		local param = params[i]
		local wrapped_info = get_wrapped_param_info(settings, style, param)
		local final_info = get_arranged_param_info(settings, style, wrapped_info, type_goes_first, is_param_one_line)

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

--- Inserts a parameter section into the docstring and an empty line (if applicable)
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_function_docs(settings, style, params)
	local docs_copy = copy_docstring(style[settings.struct.val])
	local is_empty_line_after_title = style[settings.empty_line_after_title.val]

	if is_empty_line_after_title then
		local empty_line_pos = style[settings.title_pos.val] + 1
		local line_start = docs_copy[2]
		table.insert(docs_copy, empty_line_pos, line_start)
	end
	insert_param_section(settings, style, params, docs_copy)
	return docs_copy
end

--- Parses each parameter to determine its name and type (if applicable)
-- @param params Table containing the parameters to parse
-- @param separator A string that separates the parameter name from its type (if present)
-- @param is_type_in_docs A style setting that determines whether the parameter's type should be included
-- @param is_type_first A style setting that determines which part of the parameter is considered the name (applies only when is_type_in_docs is false)
local function get_params_with_info(params, separator, is_type_in_docs, is_type_first)
	local params_info = {}
	local param_info
	for i = 1, #params do
		local param = params[i]
		local has_separator = separator ~= "" and string.find(param, separator)
		if not has_separator then
			param_info = param
		elseif has_separator and is_type_in_docs then
			param_info = vim.split(param, separator)
		else
			local name_pos = (is_type_first) and 2 or 1
			param_info = vim.split(param, separator)[name_pos]
		end

		-- Removes trailing spaces in between the param name and type when the separator is not whitespace, 
		-- ensuring such spaces are not considered part of the right-hand side of the parameter.
		if type(param_info) == "table" then
			for key, value in pairs(param_info) do
				param_info[key] = string.gsub(value, "%s+", "")
			end
		end
		table.insert(params_info, i, param_info)
	end
	return params_info

end

local function extract_comma_separated_params(line)
	local param_list = string.match(line, "%((.-)%)")
	local param_list_without_spaces = string.gsub(param_list, "%s*,%s*", ",")  -- Remove spaces around commas
	param_list_without_spaces = string.gsub(param_list_without_spaces, "%s+", " ")  -- Collapse multiple spaces into a single space
	param_list_without_spaces = string.gsub(param_list_without_spaces, "^%s*(.-)%s*$", "%1")  -- Trim leading and trailing spaces

	return vim.split(param_list_without_spaces, ",")
end

local function insert_function_docs(settings, style, line)
	local param_info_separator = style[settings.param_type_separator.val]
	local is_type_in_docs = style[settings.is_type_in_docs.val]
	local is_type_first = style[settings.is_type_first.val]
	local raw_params = extract_comma_separated_params(line)
	local params = get_params_with_info(raw_params, param_info_separator, is_type_in_docs, is_type_first)

	return generate_function_docs(settings, style, params)
end

local function get_docs_type(settings, style, line)
	if line and string.match(line, style[settings.func_keyword.val]) then
		return "function"
	else
		return nil
	end
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
	local docs_type = get_docs_type(settings, style, line)
	local line_indentation = line:match("^[^%w]*")

	local docs
	if docs_type == "function" then
		docs = insert_function_docs(settings, style, line)
	else
		docs = docs_struct
	end
	
	return add_indent_to_docs(docs, line_indentation, direction)
end

return {
	get_docstring = get_docstring
}
