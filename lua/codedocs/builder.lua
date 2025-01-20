local function insert_title(underline_char, title, gap, line_start, docs)
	local final_title = line_start .. title
	if title ~= "" then
		table.insert(docs, final_title)
	end

	if underline_char ~= "" then
		table.insert(docs, line_start .. string.rep(underline_char, #title))
	end

	if gap then
		table.insert(docs, line_start .. "")
	end
end

local function get_section(opts, general_style, section_style, items)
	local title = section_style[opts.item.title.val]
	local title_gap = general_style[opts.general.section_title_gap.val]
	local title_underline_char = general_style[opts.general.section_underline.val]

	local section = {}
	local line_start = general_style[opts.general.struct.val][2]
	insert_title(title_underline_char, title, title_gap, line_start, section)
	for _, item in pairs(items) do
		table.insert(section, item)
	end
	return section
end

local function get_docs_with_sections(opts, style, sections, docs)
	local title_gap = style.general[opts.general.title_gap.val]
	local line_start = style.general[opts.general.struct.val][2]

	if #sections > 0 and title_gap then
		table.insert(docs, style.general[opts.general.title_pos.val], line_start)
	end
	for i = 1, #sections do
		for _, item in pairs(sections[i]) do
			table.insert(docs, #docs, item)
		end
		if style.general[opts.general.section_gap.val] and i < #sections then
			table.insert(docs, #docs, line_start)
		end
	end
	if #style.general[opts.general.struct.val] == 2 then
		table.remove(docs, #docs)
	end
	return docs
end

local function get_formatted_item_info(val_1, val_2, default_val, is_inverted)
	local final_val
	if val_1 == "" and val_2 == "" then
		final_val = default_val
	elseif val_1 ~= "" and val_2 == "" then
		final_val = val_1
	elseif val_1 == "" and val_2 ~= "" then
		final_val = val_2
	else
		if not is_inverted then
			final_val = val_1 .. " " .. val_2
		else
			final_val = val_2 .. " " .. val_1
		end
	end
	return final_val
end

local function get_inline_item(standalone_name, standalone_type)
	local name_first = get_formatted_item_info(standalone_name, standalone_type, "", false)
	local type_first = get_formatted_item_info(standalone_name, standalone_type, "", true)
	return name_first, type_first
end

local function get_split_item(standalone_name, param_info, type_kw, is_type_below_name_first)
	local p_name = param_info[1]
	local p_type = param_info[2]
	local type_with_name = get_formatted_item_info(
		type_kw ~= "" and (type_kw .. " " .. p_name) or p_name, p_type, p_name, false
	)
	local final_type = (is_type_below_name_first) and type_with_name or standalone_type
	local name_first = {standalone_name, final_type}
	local type_first = {final_type, standalone_name}

	return name_first, type_first
end

local function get_item_line(opts, style, wrapped_item)
	local item_name, item_type = wrapped_item[1], wrapped_item[2]
	local item_kw, item_type_kw = style[opts.item.kw.val], style[opts.item.type_kw.val]
	local is_type_below_name_first = style[opts.item.is_type_below_name_first.val]

	local standalone_name = get_formatted_item_info(item_kw, item_name, "", false)
	local standalone_type = get_formatted_item_info(item_type_kw, item_type, "", false)

	local name_first, type_first
	if style[opts.item.inline.val] then
		name_first, type_first = get_inline_item(standalone_name, standalone_type)
	else
		name_first, type_first = get_split_item(standalone_name, wrapped_item, item_type_kw, is_type_below_name_first)
	end
	return (style[opts.item.type_first.val]) and type_first or name_first
end

local function get_wrapped_item(name_wrapper, type_wrapper, item, include_type)
	local item_name = (item.name) and item.name or ""
	local item_type = (item.type and include_type) and item.type or ""

	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name = open_name_wrapper .. item_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. item_type .. close_type_wrapper
	return {wrapped_name, wrapped_type}
end

local function get_section_lines(opts, general_style, style, items)
	local line_start = general_style[opts.general.struct.val][2]
	local base_line = (style[opts.item.indent.val]) and ("\t" .. line_start) or (line_start)
	local name_wrapper = style[opts.item.name_wrapper.val]
	local type_wrapper = style[opts.item.type_wrapper.val]
	local include_type = style[opts.item.include_type.val]

	local lines = {}

	for idx, item in ipairs(items) do
		local wrapped_item = get_wrapped_item(name_wrapper, type_wrapper, item, include_type)
		-- local final_item = get_item(wrapped_item, item_kw, item_type_kw, type_goes_first, is_type_below_name_first, item_inline)
		local item_line = get_item_line(opts, style, wrapped_item)

		if type(item_line) == "string" then
			table.insert(lines, base_line .. item_line)
		elseif type(item_line) == "table" then
			for _, value in pairs(item_line) do
				table.insert(lines, base_line .. value)
			end
		end
		if general_style[opts.general.item_gap.val] and idx < #items then
			table.insert(lines, base_line)
		end
	end
	return lines

end

local function get_sections(opts, style, sections_items)
	local general_style = style.general
	local section_order = general_style[opts.general.section_order.val]
	local sections = {}
	for _, section_name in pairs(section_order) do
		if section_name ~= "general" then
			local section_style = style[section_name]
			local section_items = sections_items[section_name]
			local lines = get_section_lines(opts, general_style, section_style, section_items)
			if #lines > 0 then
				local final_section = get_section(opts, general_style, section_style, lines)
				table.insert(sections, final_section)
			end
		end
	end
	return sections
end

local function get_docs(opts, style, data, docs_struct)
	local sections = get_sections(opts, style, data)
	return get_docs_with_sections(opts, style, sections, docs_struct)
end

return {
	get_docs = get_docs
}
