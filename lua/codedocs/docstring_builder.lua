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
local function add_indent_to_docstring(lines, indentation_string)
	local indented_lines = {}
	for _, line in pairs(lines) do
		for idx = 1, #indentation_string do
			local char = string.sub(indentation_string, idx, idx)
			line = char .. line
		end
		table.insert(indented_lines, line)
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
	local type_wrapper = template[settings.type_wrapper.val]
	local open_wrapper = type_wrapper[1]
	local close_wrapper = type_wrapper[2]
	local type_goes_before_name = template[settings.type_goes_before_name.val]

	if type_goes_before_name and type(param) == "table" then
		Param_data = base_param .. " " .. open_wrapper .. param[pos_type] .. close_wrapper .. " " .. param_name
	elseif not type_goes_before_name and type(param) == "table" then
		Param_data = base_param .. param_name .. " " .. open_wrapper .. param[pos_type] .. close_wrapper
	elseif type_goes_before_name then
		Param_data = base_param .. " " .. open_wrapper .. close_wrapper .. " " .. param
	else
		Param_data = base_param .. " " .. param .. " " .. open_wrapper .. close_wrapper
	end
	return Param_data
end

--- Adds formatted parametres to the docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring.
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param docstring (table) The docstring base structure
local function add_params_to_docstring(settings, template, params, docstring)
	if template[settings.type_pos_in_func.val] then
		Pos_name = 2
		Pos_type = 1
	else
		Pos_name = 1
		Pos_type = 2
	end
	for i = 1, #params do
		local current_param = params[i]
		local param_data = get_param_data(settings, template, current_param, Pos_name, Pos_type)
		table.insert(docstring, i + 3, param_data)
	end
end

--- Inserts a leader and parameters into the docstring
-- Adds a title (args_title) before the parameters (if applicable) and inserts the parameters into the docstring
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_docstring(settings, template, params)
	local docstring_copy = copy_docstring(template[settings.structure.val])
	local line_start = template[settings.structure.val][2]
	table.insert(docstring_copy, 3, line_start)
	add_params_to_docstring(settings, template, params, docstring_copy)
	if template[settings.params_title.val] ~= "" then
		table.insert(docstring_copy, 4, template[settings.params_title.val])
	end
	return docstring_copy
end

--- Returns the parametres found in the function under the cursor
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring.
-- @param line (string) The line under the cursor containing the function signature
-- @return (table|nil) A table with each parametre as an element, or nil if no parametres are found
local function get_params(settings, template, line)
	if line and not string.match(line, template[settings.func_keyword.val]) then
		return nil
	end
	local params_string = string.match(line, "%((.-)%)")
	local params_without_spaces = string.gsub(params_string, "%s+", "")
	local params = vim.split(params_without_spaces, ",")

	local params_with_types = {}
	local separator = template[settings.param_type_separator.val]

	for i = 1, #params do
		if separator ~= "" then
			if string.find(params[i], separator) then
				local split_param = vim.split(params[i], separator)
				string.gsub(split_param[1], ",%s+", ",")
				string.gsub(split_param[2], ",%s+", ",")
				table.insert(params_with_types, i, split_param)
			else
				table.insert(params_with_types, i, params[i])
			end
		else
			table.insert(params_with_types, i, params[i])
		end
	end
	return params_with_types
end

--- Returns a docstring with content or an empty one.
-- If parameters and/or title are detected, updates the docstring with them; otherwise, returns the original docstring.
-- @param settings (table) Keys used to access setting values in a template
-- @param template (table) Settings to configure the language's docstring.
-- @param line (string) The line under the cursor containing the function signature.
-- @return (table) The updated docstring or the original one.
local function get_docstring(settings, template, line)
	local params = get_params(settings, template, line)

	local final_docstring = {}
	if not params then
		final_docstring = template[settings.structure.val]
	elseif params and not template[settings.param_indent.val] then
		final_docstring = generate_docstring(settings, template, params)
	else
		final_docstring = generate_docstring(settings, template, params)
	end
	return add_indent_to_docstring(final_docstring, get_indent_from_line(line))
end

return {
	get_docstring = get_docstring
}
