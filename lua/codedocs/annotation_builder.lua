local Debug_logger = require "codedocs.utils.debug_logger"

local function compute_line_indent(line_row)
	assert(type(line_row) == "number", "'line_row' must be a number, got " .. type(line_row))
	assert(line_row >= 0, "'line_row' must be 0 or higher, got " .. line_row)

	local cols = vim.fn.indent(line_row)
	if cols == -1 then return "" end

	if vim.bo.expandtab then return string.rep(" ", cols) end

	local tabstop = vim.bo.tabstop
	local tabs = math.floor(cols / tabstop)
	local spaces = cols % tabstop

	return string.rep("\t", tabs) .. string.rep(" ", spaces)
end

local function get_indent_string()
	if not vim.bo.expandtab then return "\t" end

	local shiftwidth = vim.bo.shiftwidth
	if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end
	return string.rep(" ", shiftwidth)
end

local Annotation = {}

function Annotation.new()
	local new_annotation = {
		_lines = {},
		_snippet_tabstop_idx_counter = 1,
	}

	return setmetatable(new_annotation, { __index = Annotation })
end

function Annotation:get_lines() return self._lines end

function Annotation:extend(tbl, struct_data)
	for _, line in ipairs(tbl) do
		self.insert(self, line, struct_data)
	end
end

function Annotation:insert(line, struct_data)
	local SUPPORTED_GENERAL_PLACEHOLDERS = {
		indent = "%%>",
		snippet_tabstop_idx = "%%snippet_tabstop_idx",
	}

	if line ~= "" and struct_data then
		line = compute_line_indent(struct_data.line_num) .. line
		if struct_data and struct_data.should_indent then line = get_indent_string() .. line end
	end

	if line ~= "" and line:match(SUPPORTED_GENERAL_PLACEHOLDERS.snippet_tabstop_idx) then
		line = line:gsub(SUPPORTED_GENERAL_PLACEHOLDERS.snippet_tabstop_idx, function()
			local snippet_tabstop_idx_label = tostring(self._snippet_tabstop_idx_counter)

			self._snippet_tabstop_idx_counter = self._snippet_tabstop_idx_counter + 1

			return snippet_tabstop_idx_label
		end)
	end

	line = line:gsub(SUPPORTED_GENERAL_PLACEHOLDERS.indent, get_indent_string())

	table.insert(self._lines, line)
end

local function format_item_line(line, item)
	if item.name then line = line:gsub("%%item_name", item.name or "") end

	if item.type then line = line:gsub("%%item_type", item.type or "") end

	return line
end

local function _build_content(item_data, style)
	local content = {}

	for section_idx, section_name in ipairs(style.settings.section_order) do
		local section_items = item_data[section_name]
		if #section_items == 0 then goto skip_section end ---A section with no items effectively has no content

		local section_style = style.sections[section_name]

		for _, ln in ipairs(section_style.layout) do
			table.insert(content, ln)
		end

		for item_idx, item in ipairs(section_items) do
			for _, line in ipairs(section_style.items.layout) do
				local item_line = format_item_line(line, item)
				table.insert(content, item_line)

				local should_insert_item_gap = section_style.items.insert_gap_between.enabled
					and section_items[item_idx + 1]
				if should_insert_item_gap then table.insert(content, section_style.items.insert_gap_between.text) end
			end
		end

		local should_insert_section_gap = style.sections[section_name].insert_gap_between.enabled
			and style.settings.section_order[section_idx + 1]
		if should_insert_section_gap then
			table.insert(content, style.sections[section_name].insert_gap_between.text)
		end

		::skip_section::
	end
	return content
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and settings options
-- @return table Table mapping section names to their formatted content lines
return function(style, item_data, annotation_structure, struct_data)
	assert(type(item_data) == "table", "'item_data' must be a table, got " .. type(item_data))
	assert(type(style) == "table", "'style' must be a table, got " .. type(style))

	local annotation = Annotation.new()

	for i = 1, (style.settings.insert_at - 1) do
		-- Add all lines from the original layout that appear before the position where the content is to be inserted.
		--
		-- This is done to avoid inserting lines one by one at the insertion position,
		-- since that would shift all following layout lines every time and be inefficient
		-- handle_line(annotation_structure[i])
		annotation:insert(annotation_structure[i], struct_data)
	end

	for _, title_line in ipairs(style.sections.title.layout) do
		annotation:insert(title_line, struct_data)
	end

	local content = style.settings.section_order and _build_content(item_data, style) or {}
	Debug_logger.log("Annotation content", content)

	if
		(style.sections.title.insert_gap_between and style.sections.title.insert_gap_between.enabled)
		and vim.tbl_count(content) > 0
	then
		annotation:insert(style.sections.title.insert_gap_between.text, struct_data)
	end

	annotation:extend(content, struct_data)

	for i = style.settings.insert_at, #annotation_structure do
		-- Add all lines from the original layout that appear after the position where the content is to be inserted
		annotation:insert(annotation_structure[i], struct_data)
	end

	return annotation:get_lines()
end
