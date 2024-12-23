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

--- Extracts the indentation string from a line
-- Captures all leading non-alphanumeric characters (e.g., spaces or tabs) before
-- the first alphanumeric character, representing the line's indentation
-- @param line (string) The line of code to analyze
-- @return (string) The extracted indentation string
local function get_indent_from_line(line)
	return line:match("^[^%w]*")
end

--- Indents each line of a docstring by prepending an indentation string
-- Appends the specified indentation string to the beginning of each line
-- in the provided docstring
-- @param lines (table) A list of strings representing the lines of the docstring
-- @param indentation_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function add_indent_to_docstring(lines, indentation_string, direction)
	local direction_based_indent = (direction) and "" or "\t"
	local indented_lines = {}
	for _, line in pairs(lines) do
		for idx = 1, #indentation_string do
			local char = string.sub(indentation_string, idx, idx)
			line = char .. line
		end
		table.insert(indented_lines, direction_based_indent .. line)
	end
	return indented_lines
end

--- Formats and returns a parameter ready to be inserted into a docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring.
-- @param param (table | string) Either a parametre name and a parametre type, or just a parametre name
-- @param pos_name The position of the param name in the param table
-- @param pos_type The position of the param type in the param table
local function get_param_data(settings, template, param, pos_name, pos_type)
	local base_param = template[settings.structure.val][2] .. template[settings.param_keyword.val]
	if template[settings.param_indent.val] then
		base_param = "\t" .. base_param
	end
	local param_name = param[pos_name]
	local param_type = param[pos_type]
	local type_wrapper = template[settings.type_wrapper.val]
	local open_wrapper = type_wrapper[1]
	local close_wrapper = type_wrapper[2]
	local type_pos_in_docs = template[settings.type_pos_in_docs.val]

	if type_pos_in_docs and type(param) == "table" then
		Param_data = base_param .. " " .. open_wrapper .. param_type .. close_wrapper .. " " .. param_name
	elseif not type_pos_in_docs and type(param) == "table" then
		Param_data = base_param .. param_name .. " " .. open_wrapper .. param_type .. close_wrapper
	elseif type_pos_in_docs then
		Param_data = base_param .. " " .. open_wrapper .. close_wrapper .. " " .. param
	else
		Param_data = base_param .. param .. " " .. open_wrapper .. close_wrapper
	end
	return Param_data
end

--- Adds a parameter section (title + parameters) to a docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring.
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docstring (table) The docstring base structure
local function add_param_section_to_docstring(settings, template, params, docstring)
	local type_pos_in_func = template[settings.type_pos_in_func.val]
	local params_title = template[settings.params_title.val]
	local name_pos, type_pos = (type_pos_in_func) and 2 or 1, (type_pos_in_func) and 1 or 2

	if params_title ~= "" then table.insert(docstring, #docstring, params_title) end

	for i = 1, #params do
		local current_param = params[i]
		local param_data = get_param_data(settings, template, current_param, name_pos, type_pos)
		table.insert(docstring, #docstring, param_data)
	end

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

	local docs = (params) and generate_docstring(settings, template, params) or docs_struct
	return add_indent_to_docstring(docs, get_indent_from_line(line), direction)
end

return {
	get_docstring = get_docstring
}
