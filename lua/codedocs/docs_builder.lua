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
local function insert_param_section(settings, style, params, title_underline_char, docs)
	local title = style[settings.params_title.val]
	-- local title_underline_char = style[settings.section_underline.val]

	add_section_title(title_underline_char, title, docs)
	add_section_params(settings, style, params, docs)

end

local function insert_return_section(settings, style, return_type, title_underline_char, docs)
	local title = style[settings.return_title.val]
	add_section_title(title_underline_char, title, docs)
	local line_start = style[settings.struct.val][2]

	local is_return_one_line = style[settings.is_param_one_line.val]
	local return_keyword = style[settings.return_keyword.val]
	local return_type_keyword = style[settings.return_type_keyword.val]
	local type_wrapper = style[settings.return_type_wrapper.val]
	local is_type_in_docs = style[settings.is_return_type_in_docs.val]
	local wrapped_type = (is_type_in_docs) and type_wrapper[1] .. return_type .. type_wrapper[2] or type_wrapper

	local is_return_line_present = true
	local is_return_indented = style[settings.param_indent.val]
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
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
-- @return (table) A new table with the updated docstring content
local function generate_function_docs(settings, style, params, return_type)
	local docs_copy = copy_docstring(style[settings.struct.val])
	local is_empty_line_after_title = style[settings.empty_line_after_title.val]
	local title_underline_char = style[settings.section_underline.val]

	if is_empty_line_after_title then
		local empty_line_pos = style[settings.title_pos.val] + 1
		local line_start = docs_copy[2]
		table.insert(docs_copy, empty_line_pos, line_start)
	end
	insert_param_section(settings, style, params, title_underline_char, docs_copy)
	if return_type ~= nil then
		insert_return_section(settings, style, return_type, title_underline_char, docs_copy)
	end
	if #style[settings.struct.val] == 2 then table.remove(docs_copy, #docs_copy) end
	return docs_copy
end

--- Parses each parameter to determine its name and type (if applicable)
-- @param params Table containing the parameters to parse
-- @param separator A string that separates the parameter name from its type (if present)
-- @param is_type_in_docs A style setting that determines whether the parameter's type should be included
-- @param is_type_first A style setting that determines which part of the parameter is considered the name (applies only when is_type_in_docs is false)

local function get_typed_param_data(ts_utils, is_type_in_docs, param)
	local type_identifiers = {
		type = true,
		integral_type = true,
		type_annotation = true,
		type_identifier = true,
		user_type = true
	}
	local name_identifiers = {
		identifier = true,
		simple_identifier = true
	}
	local param_data = ts_utils.get_named_children(param)
	local param_name, param_type
	for _, info in ipairs(param_data) do
		local is_name = name_identifiers[info:type()]
		local is_type = type_identifiers[info:type()]
		if is_name then
			param_name = ts_utils.get_node_text(info)[1]
		elseif is_type_in_docs and (is_type or string.match(info:type(), "_type")) then
			param_type = ts_utils.get_node_text(info)[1]
		end
	end
	return {param_name, param_type}
end

local function search_return_recursively(ts_utils, child_nodes)
	local return_identifier = {
		return_statement = true
	}
	for _, node in ipairs(child_nodes) do
		local node_is_return = return_identifier[node:type()] or node:type() == "return"
		if node_is_return then
			return "unknown"
		elseif ts_utils.get_named_children(node) ~= nil then
			local result = search_return_recursively(ts_utils, ts_utils.get_named_children(node))
			if result then
				return result
			end
		end
	end
end

local function get_sig_return_type(ts_utils, func_sections)
	local type_identifier = {
		integral_type = true,
		type = true,
		type_annotation = true
	}

	local return_type
	for _, section in ipairs(func_sections) do
		local is_type_in_signature = type_identifier[section:type()] or string.match(section:type(), "_type")
		if is_type_in_signature then
			return_type = ts_utils.get_node_text(section)[1]
		end
	end
	return return_type
end

local function get_block_return_type(ts_utils, func_sections)
	local block_identifier = {
		block = true,
		statement_block = true,
		compound_statement = true,
		body_statement = true
	}

	local return_type
	for _, section in ipairs(func_sections) do
			local is_section_block = block_identifier[section:type()]
			if is_section_block then
				local block_children = ts_utils.get_named_children(section)
				return_type = search_return_recursively(ts_utils, block_children)
			end
		end
	return return_type
end

local function get_function_return_type(ts_utils, node)
	local func_sections = ts_utils.get_named_children(node)
	local return_type = get_sig_return_type(ts_utils, func_sections)
	if not return_type then
		return_type = get_block_return_type(ts_utils, func_sections)
	end
	return return_type
end

local function extract_function_params(node, ts_utils, is_type_in_docs)
	local param_section_identifiers = {
		formal_parameters = true,
		function_value_parameters = true,
		parameters = true,
		method_parameters = true
	}
	local typed_param_identifiers = {
		typed_parameter = true,
		required_parameter = true,
		formal_parameter = true,
		parameter = true
	}
	local untyped_param_identifiers = {
		identifier = true,
		simple_parameter = true
	}
	local func_sections = ts_utils.get_named_children(node)

  	local params = {}
	for _, func_section in ipairs(func_sections) do
		local is_param_section = param_section_identifiers[func_section:type()]
    	if is_param_section then
      		local param_section = ts_utils.get_named_children(func_section)
      		for _, param in ipairs(param_section) do
				local is_param_untyped = untyped_param_identifiers[param:type()]
				local is_param_typed = typed_param_identifiers[param:type()]
				local param_name, param_type
				if param and is_param_untyped then
					param_name = ts_utils.get_node_text(param)[1]
				elseif param and is_param_typed then
					local typed_param = get_typed_param_data(ts_utils, is_type_in_docs, param)
					param_name, param_type = typed_param[1], typed_param[2]
				end
			table.insert(params, {name = param_name, type = param_type})
    		end
    	end
	end
	return params
end

local function insert_function_docs(settings, style, node, ts_utils)
	local is_type_in_docs = style[settings.is_type_in_docs.val]
	local params = extract_function_params(node, ts_utils, is_type_in_docs)
	local return_type = get_function_return_type(ts_utils, node)
	return generate_function_docs(settings, style, params, return_type)
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
-- @param settings (table) Keys used to access setting values in a style
-- @param style (table) Settings to configure the language's docstring style
-- @param line (string) The line under the cursor containing the function signature
-- @return (table) The updated docstring or the original one
local function get_docstring(settings, style, line)
	local ts_utils = require'nvim-treesitter.ts_utils'
	local node = ts_utils.get_node_at_cursor()

	local docs_struct = style[settings.struct.val]
	local direction = style[settings.direction.val]
	local docs_type = get_docs_type(node)
	local line_indentation = line:match("^[^%w]*")

	local docs
	if docs_type == nil then
		docs = docs_struct
	elseif is_node_a_function(docs_type:type()) then
		docs = insert_function_docs(settings, style, docs_type, ts_utils)
	end

	return add_indent_to_docs(docs, line_indentation, direction)
end

return {
	get_docstring = get_docstring
}
