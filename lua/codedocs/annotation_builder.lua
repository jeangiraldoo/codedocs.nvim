local Debug_logger = require("codedocs.utils.debug_logger")

local function _handle_string(string, item_name, item_type, include_type)
	local result = string:gsub("%%item_name", item_name or "")
	result = include_type and result:gsub("%%item_type", item_type or "") or result:gsub("%%item_type", "")
	return result
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and general options
-- @return table Table mapping section names to their formatted content lines
local function _build_annotation_content(item_data, style)
	local annotation_content = {}

	for _, section_name in ipairs(style.general.section_order) do
		local section_items = item_data[section_name]
		local section_style = style[section_name]

		if #section_items == 0 then goto skip_section end ---A section with no items effectively has no content

		local section_content = vim.deepcopy(section_style.layout)
		for _, item in ipairs(section_items) do
			local indent = section_style.items.indent and "\t" or ""
			for _, line in ipairs(section_style.items.template) do
				local line_type = type(line)

				local final = ""
				if line_type == "string" then
					final = _handle_string(line, item.name, item.type, section_style.items.include_type)
				elseif line_type == "table" then
					for idx, line_part in ipairs(line) do
						local result = _handle_string(line_part, item.name, item.type, section_style.items.include_type)
						if idx ~= 1 and result ~= "" then final = final .. " " end
						if result ~= "" then final = final .. result end
					end
				end
				table.insert(section_content, indent .. final)
			end
		end

		annotation_content[section_name] = section_content
		::skip_section::
	end
	return annotation_content
end

--- Formats the annotation content into the final annotation structure
-- @param sections_data table Section-formatted annotation content
-- @param style table Style configuration for all sections and general options
-- @param annotation_structure table Base annotation structure to populate
-- @return table Final formatted annotation as a flat list of lines
local function _format_annotation_content(sections_data, style, annotation_layout)
	local general_opts = style.general
	local line_start = style.general.layout[2]

	local annotation_layout_copy = vim.deepcopy(annotation_layout)

	if general_opts.annotation_title.gap and vim.tbl_count(sections_data) > 0 then
		local title_gap_pos = general_opts.annotation_title.pos + 1
		table.insert(annotation_layout_copy, title_gap_pos, style.general.annotation_title.gap_text)
	end

	local sections_order = general_opts.section_order
	for section_idx, section_name in ipairs(sections_order) do
		local section_content = sections_data[section_name]

		if section_content == nil then goto skip_section end ---A section without content shouldn't be added to the annotation

		for line_idx, line in ipairs(section_content) do
			table.insert(annotation_layout_copy, #annotation_layout_copy, line)

			if style[section_name].items.insert_gap_between and section_content[line_idx + 1] then
				table.insert(annotation_layout_copy, #annotation_layout_copy, line_start)
			end
		end

		if style[section_name].gap.enabled and sections_order[section_idx + 1] then
			table.insert(annotation_layout_copy, #annotation_layout_copy, style[section_name].gap.text)
		end
		::skip_section::
	end

	-- Elements are inserted at the index of the last element, shifting that element to the right. As a result,
	-- the original last element of the base annotation structure ends up at the very end of the final annotation.
	-- This is desired when the base structure has three parts, but becomes a leftover element when it has only two
	if #annotation_layout == 2 then table.remove(annotation_layout_copy, #annotation_layout_copy) end

	return annotation_layout_copy
end

return function(style, data, annotation_structure)
	local annotation_content = _build_annotation_content(data, style)
	Debug_logger.log("Annotation content:", annotation_content)

	return _format_annotation_content(annotation_content, style, annotation_structure)
end
