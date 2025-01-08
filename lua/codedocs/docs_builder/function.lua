local function insert_title_into_section(underline_char, title, is_empty_line_under_title, line_start, docs)
	local final_title = line_start .. title
	if title ~= "" then
		table.insert(docs, final_title)
	end

	if underline_char ~= "" then
		table.insert(docs, line_start .. string.rep(underline_char, #title))
	end

	if is_empty_line_under_title then
		table.insert(docs, line_start .. "")
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
	local type_keyword = style[opts.type_kw.val]
	local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	local final_name = style[opts.param_kw.val] .. " " .. param_name
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

local function get_single_return_ln(base_ln, r_data)
	local r_kw, r_type_kw, wrapped_type = r_data[1], r_data[2], r_data[3]
	local r_ln
	if r_kw == "" and r_type_kw == "" then
		r_ln = wrapped_type
	elseif r_kw == "" and r_type_kw ~= "" then
		r_ln = r_type_kw .. " " .. wrapped_type
	elseif r_kw ~= "" and r_type_kw == "" then
		r_ln = r_kw .. " " .. wrapped_type
	else
		r_ln = r_kw .. " " .. r_type_kw .. " " .. wrapped_type
	end
	return base_ln .. r_ln
end

local function get_split_return_ln(base_ln, r_data)
	local r_kw, r_type_kw, wrapped_type = r_data[1], r_data[2], r_data[3]
	local upper_ln = base_ln .. r_kw
	local lower_ln
	if r_type_kw == "" then
		lower_ln = wrapped_type
	else
		lower_ln = r_type_kw .. " " .. wrapped_type
	end
	lower_ln = base_ln .. lower_ln
	return {upper_ln, lower_ln}
end

local function get_return_ln(is_one_line, base_ln, r_data)
	local r_ln
	if is_one_line then
		r_ln = get_single_return_ln(base_ln, r_data)
	else
		r_ln = get_split_return_ln(base_ln, r_data)
	end
	return r_ln
end

local function insert_return_ln(docs, r_ln)
	if type(r_ln) == "string" then
		table.insert(docs, r_ln)
	elseif type(r_ln) == "table" then
		for _, value in pairs(r_ln) do
			table.insert(docs, value)
		end
	end
end

local function insert_return_ln_into_section(opts, style, r_data, section)
	print("r_data")
	local r_kw, r_type_kw, r_type = r_data[1], r_data[2], r_data[3]
	print(r_type)
	local is_type_in_docs = style[opts.is_return_type_in_docs.val]
	local is_r_indented = style[opts.param_indent.val]
	local is_one_ln = style[opts.is_return_one_ln.val]

	local ln_start = style[opts.struct.val][2]
	local indent = (is_r_indented) and "\t" or ""
	local base_ln = indent .. ln_start

	local type_wrapper = style[opts.return_type_wrapper.val]
	local full_type_wrapper = type_wrapper[1] .. r_type .. type_wrapper[2]
	local empty_type_wrapper = type_wrapper[1] .. type_wrapper[2]
	local wrapped_type = (is_type_in_docs and r_type ~= "unknown") and full_type_wrapper or empty_type_wrapper

	local updated_r_data = {r_kw, r_type_kw, wrapped_type}
	local r_ln = get_return_ln(is_one_ln, base_ln, updated_r_data)

	insert_return_ln(section, r_ln)
end

local function get_return_section(opts, style, r_type)
	local section = {}
	local is_empty_line_under_title = style[opts.empty_ln_after_section_title.val]
	local title_underline_char = style[opts.section_underline.val]

	local title = style[opts.return_title.val]
	local ln_start = style[opts.struct.val][2]
	insert_title_into_section(title_underline_char, title, is_empty_line_under_title, ln_start, section)

	local r_kw = style[opts.return_kw.val]
	local r_type_kw = style[opts.return_type_kw.val]
	local is_type_in_docs = style[opts.is_return_type_in_docs.val]

	local is_return_line_present = r_kw ~= "" or r_type_kw ~= "" or (is_type_in_docs and r_type ~= "unknown")
	if is_return_line_present then
		local r_data = {r_kw, r_type_kw, r_type}
		insert_return_ln_into_section(opts, style, r_data, section)
	end
	return section
end

local function insert_params_into_section(opts, style, params, docs)
	local line_start = style[opts.struct.val][2]
	local base_line = (style[opts.param_indent.val]) and ("\t" .. line_start) or (line_start)
	local type_goes_first = style[opts.type_goes_first.val]
	local is_param_one_line = style[opts.is_param_one_ln.val]

	for i = 1, #params do
		local param = params[i]
		local wrapped_info = get_wrapped_param_info(opts, style, param)
		local final_info = get_arranged_param_info(opts, style, wrapped_info, type_goes_first, is_param_one_line)

		if type(final_info) == "string" then
			-- table.insert(docs, #docs, base_line .. final_info)
			table.insert(docs, base_line .. final_info)
		elseif type(final_info) == "table" then
			for _, value in pairs(final_info) do
				-- table.insert(docs, #docs, base_line .. value)
				table.insert(docs, base_line .. value)
			end
		end
		if style[opts.empty_ln_after_section_item.val] and i < #params then
			table.insert(docs, base_line)
		end
	end
end

--- Adds a parameter section, composed of a title and parameters, to a docstring
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param params (table) A table of parameters to be inserted into the docstring
local function get_param_section(opts, style, params)
	local is_empty_line_under_title = style[opts.empty_ln_after_section_title.val]
	local title_underline_char = style[opts.section_underline.val]

	local section = {}
	local title = style[opts.params_title.val]
	local line_start = style[opts.struct.val][2]
	insert_title_into_section(title_underline_char, title, is_empty_line_under_title, line_start, section)
	insert_params_into_section(opts, style, params, section)
	return section
end

local function get_docs_with_sections(opts, style, sections, docs)
	local is_empty_line_after_title = style[opts.empty_ln_after_title.val]
	local line_start = style[opts.struct.val][2]

	if is_empty_line_after_title then
		table.insert(docs, style[opts.title_pos.val], line_start)
	end
	for i = 1, #sections do
		for _, item in pairs(sections[i]) do
			table.insert(docs, #docs, item)
		end
		if style[opts.empty_ln_between_sections.val] and i < #sections then
			table.insert(docs, #docs, line_start)
		end
	end
	if #style[opts.struct.val] == 2 then table.remove(docs, #docs) end
	return docs
end

local function get_sections(opts, style, params, return_type)
	local sections = {}
	if #params > 0 then
		local param_section = get_param_section(opts, style, params)
		table.insert(sections, param_section)
	end
	if return_type ~= nil then
		local return_section = get_return_section(opts, style, return_type)
		table.insert(sections, return_section)
	end
	return sections
end

local function get_docs(opts, style, node, ts_utils, docs_struct)
	local is_type_in_docs = style[opts.is_type_in_docs.val]
	local func_parser = require("codedocs.struct_parser.function")
	local func_data = func_parser.get_data(node, ts_utils, is_type_in_docs)
	local params = func_data["params"]
	local return_type = func_data["return_type"]
	local sections = get_sections(opts, style, params, return_type)
	return get_docs_with_sections(opts, style, sections, docs_struct)
end

return {
	get_docs = get_docs
}
