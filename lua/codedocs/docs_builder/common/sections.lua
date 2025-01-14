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

local function get_section(opts, style, title, items)
	local title_gap = style[opts.section_title_gap.val]
	local title_underline_char = style[opts.section_underline.val]

	local section = {}
	local line_start = style[opts.struct.val][2]
	insert_title(title_underline_char, title, title_gap, line_start, section)
	for _, item in pairs(items) do
		table.insert(section, item)
	end
	return section
end

local function get_docs_with_sections(opts, style, sections, docs)
	local title_gap = style[opts.title_gap.val]
	local line_start = style[opts.struct.val][2]

	if #sections > 0 and title_gap then
		table.insert(docs, style[opts.title_pos.val], line_start)
	end
	for i = 1, #sections do
		for _, item in pairs(sections[i]) do
			table.insert(docs, #docs, item)
		end
		if style[opts.section_gap.val] and i < #sections then
			table.insert(docs, #docs, line_start)
		end
	end
	if #style[opts.struct.val] == 2 then
		table.remove(docs, #docs)
	end
	return docs
end

return {
	get_section = get_section,
	get_docs_with_sections = get_docs_with_sections
}
