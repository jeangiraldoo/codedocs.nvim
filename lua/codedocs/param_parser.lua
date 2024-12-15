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

--- Inserts a leader and parameters into the docstring
-- Adds a title (leader) before the parameters (if applicable) and inserts the parameters into the docstring
-- @param docstring_struct (table) The original table representing the docstring structure
-- @param leader (string) A string to insert before the parameters (only for some languages)
-- @param params (table) A table of parameters to be inserted into the docstring
-- @param before_arg (string) A keyword to be inserted before each parameter (only for some languages)
-- @return (table) A new table with the updated docstring content
local function update_docstring_content(docstring_struct, leader, params, before_arg)
	local docstring_copy = copy_docstring(docstring_struct)
	local line_start = docstring_struct[2]
	table.insert(docstring_copy, 3, line_start)
	if leader ~= "" then
		table.insert(params, 1, leader)
	end
	for i = 1, #params do
		table.insert(docstring_copy, i + 3, line_start .. before_arg .. params[i])
	end
	return docstring_copy
end

--- Returns the parametres found in the function under the cursor
-- @param line (string) The line under the cursor containing the function signature
-- @param func_keyword (string) The keyword used to define functions in the associated language
-- @return (table|nil) A table with each parametre as an element, or nil if no parametres are found
local function get_parametres(line, func_keyword)
	if line and string.match(line, func_keyword) then
		local params_string = string.match(line, "%((.-)%)")
		return vim.split(params_string, ", ")
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
	local detected_params = get_parametres(line, func_keyword)

	if not detected_params then
		return docstring_struct
	end
	return update_docstring_content(docstring_struct, template["leader"], detected_params, template["before_arg"])
end

return {
	get_final_docstring = get_final_docstring
}
