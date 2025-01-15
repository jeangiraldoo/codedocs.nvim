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

local function get_inline_item(standalone_name, standalone_type, is_type_first)
	local name_first, type_first
	if standalone_name == "" and standalone_type == "" then
		name_first = ""
		type_first = ""
	elseif standalone_name ~= "" and standalone_type == "" then
		name_first = standalone_name
		type_first = standalone_name
	elseif standalone_name == "" and standalone_type ~= "" then
		name_first = standalone_type
		type_first = standalone_type
	else
		name_first = standalone_name .. " " .. standalone_type
		type_first = standalone_type .. " " .. standalone_name
	end
	-- local name_first = standalone_name .. " " .. standalone_type
	-- local type_first = standalone_type .. " " .. standalone_name
	return (is_type_first) and type_first or name_first
end

local function get_split_item(standalone_name, param_info, type_kw, is_type_first, is_type_below_name_first)
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

-- local function get_standalone_item_data(kw, data)
-- 	local final_data
-- 	if kw == "" and data == "" then
-- 		final_data = 
-- 	end
-- end

local function get_item(wrapped_data, item_kw, item_type_kw, type_goes_first, is_type_below_name_first, item_inline)
	local item_name = wrapped_data[1]
	local item_type = wrapped_data[2]
	-- local item_type_kw = style[opts.param_type_kw.val]
	-- local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	-- local item_kw = style[opts.param_kw.val]
	local standalone_name = (item_kw ~= "") and item_kw .. " " .. item_name or item_name
	local standalone_type = (item_type_kw ~= "") and item_type_kw .. " " .. item_type or item_type

	local line
	if item_inline then
		line = get_inline_item(standalone_name, standalone_type, type_goes_first)
	else
		line = get_split_item(standalone_name, wrapped_data, item_type_kw, type_goes_first, is_type_below_name_first)
	end
	return line
end

local function get_wrapped_item_data(name_wrapper, type_wrapper, item, include_type)
	local item_name = (item.name) and item.name or ""
	local item_type = (item.type and include_type) and item.type or ""

	local open_name_wrapper, close_name_wrapper = name_wrapper[1], name_wrapper[2]
	local open_type_wrapper, close_type_wrapper = type_wrapper[1], type_wrapper[2]

	local wrapped_name = open_name_wrapper .. item_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. item_type .. close_type_wrapper
	return {wrapped_name, wrapped_type}
end

local function get_section_items(opts, general_style, section_style, raw_items)
	local line_start = general_style[opts.general.struct.val][2]
	local base_line = (section_style[opts.item.indent.val]) and ("\t" .. line_start) or (line_start)
	local type_first = section_style[opts.item.type_first.val]
	local item_inline = section_style[opts.item.inline.val]
	local name_wrapper = section_style[opts.item.name_wrapper.val]
	local type_wrapper = section_style[opts.item.type_wrapper.val]
	local item_kw = section_style[opts.item.kw.val]
	local item_type_kw = section_style[opts.item.type_kw.val]
	local type_goes_first = section_style[opts.item.type_first.val]
	local include_type = section_style[opts.item.include_type.val]
	local is_type_below_name_first = section_style[opts.item.is_type_below_name_first.val]

	local items = {}

	for i = 1, #raw_items do
		local raw_item = raw_items[i]
		local wrapped_info = get_wrapped_item_data(name_wrapper, type_wrapper, raw_item, include_type)
		local final_info = get_item(wrapped_info, item_kw, item_type_kw, type_goes_first, is_type_below_name_first, item_inline)

		if type(final_info) == "string" then
			-- table.insert(docs, #docs, base_line .. final_info)
			table.insert(items, base_line .. final_info)
		elseif type(final_info) == "table" then
			for _, value in pairs(final_info) do
				-- table.insert(docs, #docs, base_line .. value)
				table.insert(items, base_line .. value)
			end
		end
		if general_style[opts.general.item_gap.val] and i < #raw_items then
			table.insert(items, base_line)
		end
	end
	return items

end

local function get_sections(opts, style, sections_data)
	local general_style = style.general
	local section_order = general_style[opts.general.section_order.val]
	local sections = {}
	for _, section_name in pairs(section_order) do
		if section_name ~= "general" then
			local section_style = style[section_name]
			local section_data = sections_data[section_name]
			local items = get_section_items(opts, general_style, section_style, section_data)
			if #items > 0 then
				local final_section = get_section(opts, general_style, section_style, items)
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
