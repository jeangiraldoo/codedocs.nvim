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
local function get_indentation_string(line)
	local indentation_string = ""
	for char_pos = 1, #line do
		local char = string.sub(line, char_pos, char_pos)
		if not char:match("%w") then
			indentation_string = char .. indentation_string
		else
			break
		end
	end
	return indentation_string
end

--- Indents each line of a docstring by prepending an indentation string
-- Appends the specified indentation string to the beginning of each line
-- in the provided docstring
-- @param lines (table) A list of strings representing the lines of the docstring
-- @param indentation_string (string) The string to prepend to each line for indentation
-- @return (table) A list of indented lines
local function get_indented_docstring(lines, indentation_string)
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

--- Inserts a leader and parameters into the docstring
-- Adds a title (args_title) before the parameters (if applicable) and inserts the parameters into the docstring
-- @param docstring_struct (table) The original table representing the docstring structure
-- @param args_title (string) A string to insert before the parameters (only for some languages)
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param arg_keyword (string) A keyword to be inserted before each parameter (only for some languages)
-- @return (table) A new table with the updated docstring content
local function update_docstring_content(docstring_struct, args_title, params, arg_keyword)
	local docstring_copy = copy_docstring(docstring_struct)
	local line_start = docstring_struct[2]
	table.insert(docstring_copy, 3, line_start)
	if args_title ~= "" then
		table.insert(params, 1, args_title)
	end
	for i = 1, #params do
		table.insert(docstring_copy, i + 3, line_start .. arg_keyword .. params[i])
	end
	return docstring_copy
end

--- Returns the parametres found in the function under the cursor
-- @param line (string) The line under the cursor containing the function signature
-- @param func_keyword (string) The keyword used to define functions in the associated language
-- @param indentation (bool) Controls whether parameters are indented.
-- @return (table|nil) A table with each parametre as an element, or nil if no parametres are found
local function get_parametres(line, func_keyword, indentation)
	local indentation_string = "\t"
	if not indentation then
		indentation_string = ""
	end

	if line and string.match(line, func_keyword) then
		local params_string = string.match(line, "%((.-)%)")
		local params = vim.split(params_string, ", ")

		for i = 1, #params do
			params[i] = indentation_string .. params[i]
		end
		return params
	end
	return nil
end

--- Returns a docstring with content or an empty one.
-- If parameters and/or title are detected, updates the docstring with them; otherwise, returns the original docstring.
-- @param template (table) Settings to configure the language's docstring.
-- @param docstring_struct (table) The structure of the docstring.
-- @param line (string) The line under the cursor containing the function signature.
-- @return (table) The updated docstring or the original one.
local function get_final_docstring(template, docstring_struct, line)
	local func_keyword = template["func"]
	local func_indentation_string = get_indentation_string(line)
	local detected_params = get_parametres(line, func_keyword, template["param_indent"])
	local final_docstring = {}

	if not detected_params then
		final_docstring = docstring_struct
	else
		final_docstring = update_docstring_content(docstring_struct, template["params_title"], detected_params, template["param_keyword"])
	end
	return get_indented_docstring(final_docstring, func_indentation_string)
end

return {
	get_final_docstring = get_final_docstring
}
