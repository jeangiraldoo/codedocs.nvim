local opts

local function insert_title(underline_char, title, gap, line_start, docs)
	local final_title = line_start .. title
	if title ~= "" then table.insert(docs, final_title) end

	if underline_char ~= "" then table.insert(docs, line_start .. string.rep(underline_char, #title)) end

	if gap then table.insert(docs, line_start .. "") end
end

local function get_section(general_style, style, items)
	local title = style[opts.title.val]
	local title_gap = general_style[opts.section_title_gap.val]
	local title_underline_char = general_style[opts.section_underline.val]

	local section = {}
	local line_start = general_style[opts.struct.val][2]
	local base_line = style[opts.indent.val] and ("\t" .. line_start) or line_start
	insert_title(title_underline_char, title, title_gap, line_start, section)
	for idx, item in pairs(items) do
		table.insert(section, base_line .. item)
		if general_style[opts.item_gap.val] and idx < #items then table.insert(section, base_line) end
	end
	return section
end

local function get_docs_with_sections(style, sections, docs)
	local title_gap = style.general[opts.title_gap.val]
	local line_start = style.general[opts.struct.val][2]

	if #sections > 0 and title_gap then table.insert(docs, style.general[opts.title_pos.val], line_start) end
	for i = 1, #sections do
		for _, item in pairs(sections[i]) do
			table.insert(docs, #docs, item)
		end
		if style.general[opts.section_gap.val] and i < #sections then table.insert(docs, #docs, line_start) end
	end
	if #style.general[opts.struct.val] == 2 then table.remove(docs, #docs) end
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

local function get_split_item(standalone_name, param_info, type_kw, is_type_below_name_first, standalone_type)
	local p_name, p_type = unpack(param_info)
	local type_with_name =
		get_formatted_item_info(type_kw ~= "" and (type_kw .. " " .. p_name) or p_name, p_type, p_name, false)
	local final_type = is_type_below_name_first and type_with_name or standalone_type
	local name_first = { standalone_name, final_type }
	local type_first = { final_type, standalone_name }

	return name_first, type_first
end

local function get_item_line(style, wrapped_item)
	local item_name, item_type = unpack(wrapped_item)
	local item_kw, item_type_kw = style[opts.name_kw.val], style[opts.type_kw.val]
	local is_type_below_name_first = style[opts.is_type_below_name_first.val]

	local standalone_name = get_formatted_item_info(item_kw, item_name, "", false)
	local standalone_type = get_formatted_item_info(item_type_kw, item_type, "", false)

	local name_first, type_first
	if style[opts.inline.val] then
		name_first, type_first = get_inline_item(standalone_name, standalone_type)
	else
		name_first, type_first =
			get_split_item(standalone_name, wrapped_item, item_type_kw, is_type_below_name_first, standalone_type)
	end
	return style[opts.type_first.val] and type_first or name_first
end

local function get_wrapped_item(style, item)
	local include_type = (item.type and style[opts.include_type.val])
	local item_name = item.name and item.name or ""
	local item_type = include_type and item.type or ""
	local name_wrapper, type_wrapper = style[opts.name_wrapper.val], style[opts.type_wrapper.val]

	local open_name_wrapper, close_name_wrapper = unpack(name_wrapper)
	local open_type_wrapper, close_type_wrapper = unpack(type_wrapper)

	local wrapped_name = open_name_wrapper .. item_name .. close_name_wrapper
	local wrapped_type = open_type_wrapper .. item_type .. close_type_wrapper
	return { wrapped_name, wrapped_type }
end

local function get_section_lines(style, items)
	local lines = vim.iter(items)
		:map(function(item)
			local wrapped_item = get_wrapped_item(style, item)
			local item_line = get_item_line(style, wrapped_item)
			return type(item_line) == "string" and item_line or unpack(item_line)
		end)
		:totable()
	return lines
end

local function get_docs_lines(style, sections_items)
	local general_style = style.general
	local section_order = general_style[opts.section_order.val]
	local sections = vim.iter(section_order)
		:map(function(name)
			local section_style, sections_items = style[name], sections_items[name]
			local lines = get_section_lines(section_style, sections_items)
			if #lines > 0 then return get_section(general_style, section_style, lines) end
		end)
		:totable()
	return sections
end

local function get_docs(options, style, data, docs_struct)
	opts = options
	local docs_lines = get_docs_lines(style, data)
	return get_docs_with_sections(style, docs_lines, vim.deepcopy(docs_struct))
end

return {
	get_docs = get_docs,
}
