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

local function _should_insert_gap_between_sections(section_idx, style, section_style, item_data)
	local current_section_is_last = section_idx == #style.sections
	if current_section_is_last then return false end

	local next_section = style.sections[section_idx + 1]
	local next_section_is_item_based = next_section and type(next_section.items) == "table"
	if not next_section_is_item_based then
		return section_style.insert_gap_between.enabled and not next_section.ignore_prev_gap
	end

	local next_section_has_items = item_data[next_section.name] and #item_data[next_section.name] > 0

	if not next_section_has_items then return false end

	if #next_section.layout == 0 and #next_section.items.layout == 0 then return false end

	return section_style.insert_gap_between.enabled and not next_section.ignore_prev_gap
end

local function _add_section_content(content, item_data, section_style)
	local section_items = item_data[section_style.name]
	local is_item_based_section = type(section_style.items) == "table"
	if not is_item_based_section then
		vim.list_extend(content, section_style.layout)
		return
	end

	if section_items and #section_items > 0 then
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
	end
end

local function _build_content(item_data, style)
	local content = {}

	for section_idx, section_style in ipairs(style.sections) do
		_add_section_content(content, item_data, section_style)

		if _should_insert_gap_between_sections(section_idx, style, section_style, item_data) then
			table.insert(content, section_style.insert_gap_between.text)
		end
	end

	return content
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and settings options
-- @return table Table mapping section names to their formatted content lines
return function(style, item_data, struct_data)
	assert(type(item_data) == "table", "'item_data' must be a table, got " .. type(item_data))
	assert(type(style) == "table", "'style' must be a table, got " .. type(style))

	local annotation = Annotation.new()

	local content = _build_content(item_data, style) or {}
	Debug_logger.log("Annotation content", content)

	annotation:extend(content, struct_data)

	return annotation:get_lines()
end
