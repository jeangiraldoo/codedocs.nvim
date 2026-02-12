local Debug_logger = require("codedocs.utils.debug_logger")

local function _handle_string(string, item_name, item_type)
	assert(type(string) == "string", "'string' must be a string, got " .. type(string))
	assert(type(item_name) == "string", "'item_name' must be a string, got " .. type(item_name))
	assert(type(item_type) == "string", "'item_type' must be a string, got " .. type(item_type))

	local result = string:gsub("%%item_name", item_name or ""):gsub("%%item_type", item_type)
	return result
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and settings options
-- @return table Table mapping section names to their formatted content lines
local function _build_annotation_content(item_data, style)
	assert(type(item_data) == "table", "'item_data' must be a table, got " .. type(item_data))
	assert(type(style) == "table", "'style' must be a table, got " .. type(style))

	local annotation_content = {}

	for section_idx, section_name in ipairs(style.settings.section_order) do
		local section_items = item_data[section_name]
		local section_style = style[section_name]

		if #section_items == 0 then goto skip_section end ---A section with no items effectively has no content

		local section_content = vim.deepcopy(section_style.layout)
		vim.list_extend(annotation_content, section_content)
		for item_idx, item in ipairs(section_items) do
			local indent = section_style.items.indent and "\t" or ""
			for _, line in ipairs(section_style.items.template) do
				table.insert(annotation_content, indent .. _handle_string(line, item.name, item.type))

				local should_insert_item_gap = section_style.items.insert_gap_between.enabled
					and section_items[item_idx + 1]
				if should_insert_item_gap then
					table.insert(annotation_content, section_style.items.insert_gap_between.text)
				end
			end
		end

		local should_insert_section_gap = style[section_name].insert_gap_between.enabled
			and style.settings.section_order[section_idx + 1]
		if should_insert_section_gap then
			table.insert(annotation_content, style[section_name].insert_gap_between.text)
		end

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

	local snippet_tabstop = {
		idx_counter = 1,
		pattern = "%%snippet_tabstop_idx",
	}

	local annotation = {}

	local function handle_line(line)
		if line:match(snippet_tabstop.pattern) then
			line = line:gsub(snippet_tabstop.pattern, function()
				local snippet_tabstop_idx_label = tostring(snippet_tabstop.idx_counter)

				snippet_tabstop.idx_counter = snippet_tabstop.idx_counter + 1

				return snippet_tabstop_idx_label
			end)
		end
		table.insert(annotation, line)
	end

	for i = 1, (insert_at - 1) do
		-- Add all lines from the original layout that appear before the position where the content is to be inserted.
		--
		-- This is done to avoid inserting lines one by one at the insertion position,
		-- since that would shift all following layout lines every time and be inefficient
		handle_line(annotation_layout[i])
	end

	for _, title_line in ipairs(title_opts.layout) do
		handle_line(title_line)
	end

	if (title_opts.insert_gap_between and title_opts.insert_gap_between.enabled) and vim.tbl_count(content) > 0 then
		table.insert(annotation, title_opts.insert_gap_between.text)
	end

	for _, line in ipairs(content) do
		handle_line(line)
	end

	for i = insert_at, #annotation_layout do
		-- Add all lines from the original layout that appear after the position where the content is to be inserted
		handle_line(annotation_layout[i])
	end

	return annotation
end

return function(style, data, annotation_structure)
	local annotation_content = vim.tbl_isempty(data) and {} or _build_annotation_content(data, style)
	Debug_logger.log("Annotation content:", annotation_content)

	return _format_annotation_content(annotation_structure, annotation_content, style.settings.insert_at, style.title)
end
