local Debug_logger = require("codedocs.utils.debug_logger")

local function _handle_string(string, item_name, item_type, include_type)
	assert(type(string) == "string", "'string' must be a string, got " .. type(string))
	assert(type(item_name) == "string", "'item_name' must be a string, got " .. type(item_name))
	assert(type(item_type) == "string", "'item_type' must be a string, got " .. type(item_type))
	assert(type(include_type) == "boolean", "'include_type' must be a string, got " .. type(include_type))

	local result = string:gsub("%%item_name", item_name or "")
	result = include_type and result:gsub("%%item_type", item_type or "") or result:gsub("%%item_type", "")
	return result
end

local function _build_line(line, item, opts)
	assert(type(line) == "string" or type(line) == "table", "'line' must be a table or a string, got " .. type(line))
	assert(type(item) == "table", "'item' must be a table, got " .. type(item))
	assert(type(opts) == "table", "'opts' must be a table, got " .. type(opts))

	local line_type = type(line)

	if line_type == "string" then return _handle_string(line, item.name, item.type, opts.items.include_type) end

	local final = ""
	if line_type == "table" then
		for idx, line_part in ipairs(line) do
			local result = _handle_string(line_part, item.name, item.type, opts.items.include_type)
			if idx ~= 1 and result ~= "" then final = final .. " " end
			if result ~= "" then final = final .. result end
		end
	end
	return final
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and general options
-- @return table Table mapping section names to their formatted content lines
local function _build_annotation_content(item_data, style)
	assert(type(item_data) == "table", "'item_data' must be a table, got " .. type(item_data))
	assert(type(style) == "table", "'style' must be a table, got " .. type(style))

	local annotation_content = {}

	for section_idx, section_name in ipairs(style.general.section_order) do
		local section_items = item_data[section_name]
		local section_style = style[section_name]

		if #section_items == 0 then goto skip_section end ---A section with no items effectively has no content

		local section_content = vim.deepcopy(section_style.layout)
		vim.list_extend(annotation_content, section_content)
		for item_idx, item in ipairs(section_items) do
			local indent = section_style.items.indent and "\t" or ""
			for _, line in ipairs(section_style.items.template) do
				table.insert(annotation_content, indent .. _build_line(line, item, section_style))

				local should_insert_item_gap = section_style.items.insert_gap_between.enabled
					and section_items[item_idx + 1]
				if should_insert_item_gap then
					table.insert(annotation_content, section_style.items.insert_gap_between.text)
				end
			end
		end

		local should_insert_section_gap = style[section_name].gap.enabled
			and style.general.section_order[section_idx + 1]
		if should_insert_section_gap then table.insert(annotation_content, style[section_name].gap.text) end

		::skip_section::
	end
	return annotation_content
end

---Formats the annotation content into the final annotation structure
---@param annotation_layout string[] Base annotation structure to populate
---@param content string[] Lines that will be inserted as the annotation content
---@param insert_at number Position to insert annotation lines into
---@param title_opts table Title section opts
---@return string[] annotation Final formatted annotation as a flat list of lines
local function _format_annotation_content(annotation_layout, content, insert_at, title_opts)
	assert(type(annotation_layout) == "table", "'annotation_layout' must be a table, got " .. type(annotation_layout))
	assert(type(content) == "table", "'content' must be a table, got " .. type(content))
	assert(type(title_opts) == "table", "'title_opts' must be a table, got " .. type(title_opts))

	assert(type(insert_at) == "number", "'insert_at' must be a number, got " .. type(insert_at))
	assert(insert_at >= 0, "'insert_at' must be 0 or higher, got " .. insert_at)

	local annotation = {}

	for i = 1, (insert_at - 1) do
		-- Add all lines from the original layout that appear before the position where the content is to be inserted.
		--
		-- This is done to avoid inserting lines one by one at the insertion position,
		-- since that would shift all following layout lines every time and be inefficient
		table.insert(annotation, annotation_layout[i])
	end

	for _, title_line in ipairs(title_opts.layout) do
		table.insert(annotation, title_line)
	end

	if title_opts.gap.enabled and vim.tbl_count(content) > 0 then table.insert(annotation, title_opts.gap.text) end

	for _, line in ipairs(content) do
		table.insert(annotation, line)
	end

	for i = insert_at, #annotation_layout do
		-- Add all lines from the original layout that appear after the position where the content is to be inserted
		table.insert(annotation, annotation_layout[i])
	end

	return annotation
end

return function(style, data, annotation_structure)
	local annotation_content = _build_annotation_content(data, style)
	Debug_logger.log("Annotation content:", annotation_content)

	return _format_annotation_content(annotation_structure, annotation_content, style.general.insert_at, style.title)
end
