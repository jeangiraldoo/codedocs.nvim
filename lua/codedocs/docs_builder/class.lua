local common_sections = require("codedocs.docs_builder.common.sections")
local get_section = common_sections.get_section
local get_docs_with_sections = common_sections.get_docs_with_sections

local function get_wrapped_attr_info(opts, style, attr)
	local name_wrapper = style[opts.attr_name_wrapper.val]
	local type_wrapper = style[opts.attr_type_wrapper.val]

	local attr_name = attr.name
	local attr_type = (attr.type) and attr.type or ""

	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name = open_name_wrapper .. attr_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. attr_type .. close_type_wrapper
	return {wrapped_name, wrapped_type}
end

local function get_inline_attr_line(standalone_name, standalone_type, is_type_first)
	local name_first = standalone_name .. " " .. standalone_type
	local type_first = standalone_type .. " " .. standalone_name
	return (is_type_first) and type_first or name_first
end

local function get_split_attr_line(standalone_name, attr_info, type_kw, is_type_first, is_type_below_name_first)
	local p_name = attr_info[1]
	local p_type = attr_info[2]
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

local function get_arranged_attr_info(opts, style, wrapped_attr, type_goes_first, attr_inline)
	local p_name = wrapped_attr[1]
	local p_type = wrapped_attr[2]
	local type_kw = style[opts.attr_type_kw.val]
	local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	local attr_kw = style[opts.attr_kw.val]
	local standalone_name = (attr_kw ~= "") and attr_kw .. " " .. p_name or p_name
	local standalone_type = (type_kw ~= "") and type_kw .. " " .. p_type or p_type

	local line
	if attr_inline then
		line = get_inline_attr_line(standalone_name, standalone_type, type_goes_first)
	else
		line = get_split_attr_line(standalone_name, wrapped_attr, type_kw, type_goes_first, is_type_below_name_first)
	end
	
	return line
end


local function get_attr_items(opts, style, attrs)
	local line_start = style[opts.struct.val][2]
	local base_line = (style[opts.attr_indent.val]) and ("\t" .. line_start) or (line_start)
	local type_first = style[opts.attr_type_first.val]
	local attr_inline = style[opts.attr_inline.val]
	local items = {}

	for i = 1, #attrs do
		local attr = attrs[i]
		local wrapped_info = get_wrapped_attr_info(opts, style, attr)
		local final_info = get_arranged_attr_info(opts, style, wrapped_info, type_first, attr_inline)

		if type(final_info) == "string" then
			table.insert(items, base_line .. final_info)
		elseif type(final_info) == "table" then
			for _, value in pairs(final_info) do
				table.insert(items, base_line .. value)
			end
		end
		if style[opts.item_gap.val] and i < #attrs then
			table.insert(items, base_line)
		end
	end
	return items
end

local function get_docs(opts, style, attrs, docs_struct)
	local attrs_title = style[opts.attrs_title.val]
	local attr_items = get_attr_items(opts, style, attrs)
	local attr_section = get_section(opts, style, attrs_title, attr_items)
	local sections = {attr_section}
	return get_docs_with_sections(opts, style, sections, docs_struct)
end

return {
	get_docs = get_docs
}
