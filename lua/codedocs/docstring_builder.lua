--- Creates a copy of a language's docstring structure
-- @param docstring_struct (table) The original table representing the docstring structure
-- @return (table) A new table that is a copy of "docstring_struct"
local function copy_docstring(docstring_struct)
	local copied_docstring = {}
	for i = 1, #docstring_struct do
		local copied_elem = docstring_struct[i]
		table.insert(copied_docstring, i, copied_elem)
	end
	return copied_docstring
end

--- Indents each line of a docstring by prepending an indentation string
-- @param docstring (table) A list of strings representing the lines of the docstring
-- @param indentation_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function add_indent_to_docstring(docstring, indent_string, direction)
	local direction_based_indent = (direction) and "" or "\t"
	local indented_lines = {}
	for _, line in pairs(docstring) do
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
-- @param docstring Docstring to insert the section title into
local function add_section_title(underline_char, title, docstring)
	if title ~= "" then table.insert(docstring, #docstring, title) end

	if underline_char ~= "" then
		table.insert(docstring, #docstring, string.rep(underline_char, #title))
	end
end

--- Returns a line with formatted parameter info ready to be inserted into the docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param wrapped_param (table) Wrapped param name and type
-- @param is_type_before_name (boolean) Determines if the param type goes before the name or not
-- @return string
local function get_single_line_param_data(settings, template, wrapped_param, is_type_before_name)
	local name_before_type = wrapped_param[1] .. wrapped_param[2]
	local type_before_name = wrapped_param[2] .. wrapped_param[1]

	return (is_type_before_name) and type_before_name or name_before_type
end

--- Returns 2 lines with formatted info about a parameter, one with its name and the other with its type
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param wrapped_param (table) Wrapped param name and type
-- @param is_type_before_name (boolean) Determines if the param type goes a line above the name or not
-- @return table
local function get_multi_line_param_data(settings, template, wrapped_param, is_type_before_name)
	local name_line = wrapped_param[1]
	local type_line = wrapped_param[2]

	local type_above_name = {type_line, name_line}
	local name_above_type = {name_line, type_line}

	return (is_type_before_name) and type_above_name or name_above_type
end

--- Returns the wrapped parameter name and type, with their respective keywords prepended
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param param (table | string) Parameter found in the function declaration. A table if it has a type, a string otherwise
-- @return table
local function get_wrapped_param_data(settings, template, param)
	local type_pos_in_func = template[settings.type_pos_in_func.val]
	local name_wrapper = template[settings.name_wrapper.val]
	local type_wrapper = template[settings.type_wrapper.val]
	local param_keyword = template[settings.param_keyword.val]
	local type_keyword = template[settings.type_keyword.val]

	local name_pos, type_pos = (type_pos_in_func) and 2 or 1, (type_pos_in_func) and 1 or 2
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
	local final_name = param_keyword .. " " .. wrapped_name
	local final_type = type_keyword .. " " .. wrapped_type
	return {final_name, final_type}
end

--- Inserts a section with content related to parameters into the docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docstring (table) The docstring base structure
local function add_section_params(settings, template, params, docstring)
	local line_start = template[settings.structure.val][2]
	local param_indent = template[settings.param_indent.val]
	local base_line = (param_indent) and ("\t" .. line_start) or (line_start)
	local is_type_before_name_in_docs = template[settings.type_pos_in_docs.val]

	for i = 1, #params do
		local current_param = params[i]
		local wrapped_param_data = get_wrapped_param_data(settings, template, current_param)
		local param_data
		if template[settings.is_param_data_one_line.val] then
			param_data = get_single_line_param_data(settings, template, wrapped_param_data, is_type_before_name_in_docs)
		else
			param_data = get_multi_line_param_data(settings, template, wrapped_param_data, is_type_before_name_in_docs)
		end

		if type(param_data) == "string" then
			table.insert(docstring, #docstring, base_line .. param_data)
		elseif type(param_data) == "table" then
			for _, value in pairs(param_data) do
				table.insert(docstring, #docstring, base_line .. value)
			end
		end
	end
end

--- Adds a parameter section (title + parameters) to a docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docstring (table) The docstring base structure
local function add_param_section_to_docstring(settings, template, params, docstring)
	local params_title = template[settings.params_title.val]
	local title_underline = template[settings.section_underline.val]

	add_section_title(title_underline, params_title, docstring)
	add_section_params(settings, template, params, docstring)

	if #template[settings.structure.val] == 2 then table.remove(docstring, #docstring) end
end

--- Fills a docstring with a parameter section and an empty line (if applicable)
-- and inserts the parameters into the docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_docstring(settings, template, params)
	local is_empty_line_after_title = template[settings.empty_line_after_title.val]
	local empty_line_pos = template[settings.title_pos.val] + 1
	local docs_copy = copy_docstring(template[settings.structure.val])
	local line_start = docs_copy[2]

	if is_empty_line_after_title then table.insert(docs_copy, empty_line_pos, line_start) end
	add_param_section_to_docstring(settings, template, params, docs_copy)
	return docs_copy
end

--- Returns a table of parameters, which may include names with types, names without types, or both
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param line (string) Text on the line under the cursor containing the function signature
-- @return (table | nil) A table with parameters as elements, nil if no parameters are found
local function get_params(settings, template, line)
	if line and not string.match(line, template[settings.func_keyword.val]) then
		return nil
	end
	local separator = template[settings.param_type_separator.val]

	local params_string = string.match(line, "%((.-)%)")
	local params_without_spaces = string.gsub(params_string, "%s+", "")
	local params = vim.split(params_without_spaces, ",")
	local params_with_types = {}

	local final_param_to_insert
	for i = 1, #params do
		local current_param = params[i]
		if separator ~= "" and string.find(current_param, separator) then
			final_param_to_insert = vim.split(current_param, separator)
		else
			final_param_to_insert = current_param
		end
		table.insert(params_with_types, i, final_param_to_insert)
	end
	return params_with_types
end

--- Returns a docstring with content or an empty one
-- If parameters are detected, returns a docstring with them; else, returns its base structure
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param line (string) The line under the cursor containing the function signature
-- @return (table) The updated docstring or the original one
local function get_docstring(settings, template, line)
	local docs_struct = template[settings.structure.val]
	local direction = template[settings.direction.val]
	local params = get_params(settings, template, line)
	local line_indentation = line:match("^[^%w]*")

	local docs = (params) and generate_docstring(settings, template, params) or docs_struct
	return add_indent_to_docstring(docs, line_indentation, direction)
end

return {
	get_docstring = get_docstring
}
