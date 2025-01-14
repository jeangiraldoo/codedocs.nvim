local common_sections = require("codedocs.docs_builder.common.sections")
local get_section = common_sections.get_section
local get_docs_with_sections = common_sections.get_docs_with_sections

--- Wraps the parameter's name and type
-- @param opts (table) Keys used to access option values in a style
-- @param style (table) Options to configure the language's docstring
-- @param param (table | string) Parameter found in the function declaration. A table if it has a type, a string otherwise
-- @return table
local function get_wrapped_param_info(opts, style, param)
	local name_wrapper = style[opts.param_name_wrapper.val]
	local type_wrapper = style[opts.param_type_wrapper.val]

	local param_name = param.name
	local param_type = (param.type) and param.type or ""

	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name = open_name_wrapper .. param_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. param_type .. close_type_wrapper
	return {wrapped_name, wrapped_type}
end

local function get_inline_param_line(standalone_name, standalone_type, is_type_first)
	local name_first = standalone_name .. " " .. standalone_type
	local type_first = standalone_type .. " " .. standalone_name
	return (is_type_first) and type_first or name_first
end

local function get_split_param_line(standalone_name, param_info, type_kw, is_type_first, is_type_below_name_first)
	local p_name = param_info[1]
	local p_type = param_info[2]
	local type_with_name
	if type_kw == "" and p_type == "" then
		type_with_name = p_name
	elseif type_kw ~= "" and p_type == "" then
		type_with_name = type_kw .. " " .. p_name
	elseif type_kw == "" and p_type ~= "" then
		type_with_name = p_type .. " " .. p_name
	else
		type_with_name = type_kw .. " " .. p_name .. " " .. p_type
	end
	final_type = (is_type_below_name_first) and type_with_name or standalone_type
	name_first = {standalone_name, final_type}
	type_first = {final_type, standalone_name}

	return (is_type_first) and type_first or name_first
end

--- Returns a parameter's data arranged either across a single line or 2
-- @param wrapped_param (table) Contains the parameter's name and type ready to be arranged
-- @param type_goes_first (boolean) Determines if the parameter's type goes before the name in the docstring
-- @param param_inline (boolean) Determines if the parameter's name and type are arranged in 1 line or 2
local function get_arranged_param_info(opts, style, wrapped_param, type_goes_first, param_inline)
	local p_name = wrapped_param[1]
	local p_type = wrapped_param[2]
	local type_kw = style[opts.param_type_kw.val]
	local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	local param_kw = style[opts.param_kw.val]
	local standalone_name = (param_kw ~= "") and param_kw .. " " .. p_name or p_name
	local standalone_type = (type_kw ~= "") and type_kw .. " " .. p_type or p_type

	local line
	if param_inline then
		line = get_inline_param_line(standalone_name, standalone_type, type_goes_first)
	else
		line = get_split_param_line(standalone_name, wrapped_param, type_kw, type_goes_first, is_type_below_name_first)
	end
	
	return line
	-- local final_type, name_first, type_first
	-- if param_inline then
	-- 	name_first = standalone_name .. standalone_type
	-- 	type_first = standalone_type .. standalone_name
	-- else
	-- 	local type_with_name = type_kw .. " " .. p_name .. " " .. p_type
	-- 	final_type = (is_type_below_name_first) and type_with_name or standalone_type
	-- 	name_first = {final_name, final_type}
	-- 	type_first = {final_type, final_name}
	-- end
	-- return (type_goes_first) and type_first or name_first
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
	local r_kw, r_type_kw, r_type = r_data[1], r_data[2], r_data[3]
	local include_type = style[opts.include_return_type.val]
	local is_r_indented = style[opts.param_indent.val]
	local return_inline = style[opts.return_inline.val]

	local ln_start = style[opts.struct.val][2]
	local indent = (is_r_indented) and "\t" or ""
	local base_ln = indent .. ln_start

	local type_wrapper = style[opts.return_type_wrapper.val]
	local full_type_wrapper = type_wrapper[1] .. r_type .. type_wrapper[2]
	local empty_type_wrapper = type_wrapper[1] .. type_wrapper[2]
	local wrapped_type = (include_type and r_type ~= "unknown") and full_type_wrapper or empty_type_wrapper

	local updated_r_data = {r_kw, r_type_kw, wrapped_type}
	local r_ln = get_return_ln(return_inline, base_ln, updated_r_data)

	insert_return_ln(section, r_ln)
end

local function get_return_items(opts, style, r_type)
	local items = {}
	local r_kw = style[opts.return_kw.val]
	local r_type_kw = style[opts.return_type_kw.val]
	local include_type = style[opts.include_return_type.val]

	local is_return_line_present = r_kw ~= "" or r_type_kw ~= "" or (include_type and r_type ~= "unknown")
	if is_return_line_present then
		local r_data = {r_kw, r_type_kw, r_type}
		insert_return_ln_into_section(opts, style, r_data, items)
	else
		table.insert(items, ln_start)
	end
	return items
end

local function get_param_items(opts, style, params)
	local line_start = style[opts.struct.val][2]
	local base_line = (style[opts.param_indent.val]) and ("\t" .. line_start) or (line_start)
	local type_first = style[opts.param_type_first.val]
	local param_inline = style[opts.param_inline.val]
	local items = {}

	for i = 1, #params do
		local param = params[i]
		local wrapped_info = get_wrapped_param_info(opts, style, param)
		local final_info = get_arranged_param_info(opts, style, wrapped_info, type_first, param_inline)

		if type(final_info) == "string" then
			-- table.insert(docs, #docs, base_line .. final_info)
			table.insert(items, base_line .. final_info)
		elseif type(final_info) == "table" then
			for _, value in pairs(final_info) do
				-- table.insert(docs, #docs, base_line .. value)
				table.insert(items, base_line .. value)
			end
		end
		if style[opts.item_gap.val] and i < #params then
			table.insert(items, base_line)
		end
	end
	return items
end

local function get_docs(opts, style, data, docs_struct)
	local params, return_type = data["params"], data["return_type"]
	local param_items = get_param_items(opts, style, params)
	local param_title = style[opts.params_title.val]
	local param_section = get_section(opts, style, param_title, param_items)

	local return_items = get_return_items(opts, style, return_type)
	local return_title = style[opts.return_title.val]
	local return_section = get_section(opts, style, return_title, return_items)
	local sections = {param_section, return_section, nil}
	print(vim.inspect(sections))
	return get_docs_with_sections(opts, style, sections, docs_struct)
end

return {
	get_docs = get_docs
}
