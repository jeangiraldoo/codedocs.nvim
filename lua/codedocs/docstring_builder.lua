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

--- Inserts a leader and parameters into the docstring
-- Adds a title (args_title) before the parameters (if applicable) and inserts the parameters into the docstring
-- @param template (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_docstring(template, params)
	local docstring_copy = copy_docstring(template["struct"])
	local line_start = template["struct"][2]
	table.insert(docstring_copy, 3, line_start)
	if template["params_title"] ~= "" then
		table.insert(params, 1, template["params_title"])
	end
	for i = 1, #params do
		table.insert(docstring_copy, i + 3, line_start .. template["param_keyword"] .. params[i])
	end
	return docstring_copy
end

--- Adds a tab character ("\t") to the beginning of each string in a table
-- This function modifies the input table in-place, prepending a "\t" to each element
-- @param params (table) A table of strings, where each string represents a parameter
local function add_indent_to_params(params)
	for i = 1, #params do
		params[i] = "\t" .. params[i]
	end
end

--- Returns the parametres found in the function under the cursor
-- @param template (table) Settings to configure the language's docstring.
-- @param line (string) The line under the cursor containing the function signature
-- @return (table|nil) A table with each parametre as an element, or nil if no parametres are found
local function get_params(template, line)
	if line and not string.match(line, template["func"]) then
		return nil
	end
	local params_string = string.match(line, "%((.-)%)")
	return vim.split(params_string, ", ")
end

--- Returns a docstring with content or an empty one.
-- If parameters and/or title are detected, updates the docstring with them; otherwise, returns the original docstring.
-- @param template (table) Settings to configure the language's docstring.
-- @param line (string) The line under the cursor containing the function signature.
-- @return (table) The updated docstring or the original one.
local function get_docstring(template, line)
	local params = get_params(template, line)

	local final_docstring = {}
	if not params then
		final_docstring = template["struct"]
	elseif params and not template["param_indent"] then
		final_docstring = generate_docstring(template, params)
	else
		add_indent_to_params(params)
		final_docstring = generate_docstring(template, params)
	end
	return add_indent_to_docstring(final_docstring, get_indent_from_line(line))
end

return {
	get_docstring = get_docstring
}
