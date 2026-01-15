local Debug_logger = require("codedocs.utils.debug_logger")
local opts = require("codedocs.specs._langs.style_opts")

-- @param title string Section title
-- @param title_gap boolean Whether to insert a blank line between the title and the first section item
-- @param underline_char string Character used to underline the title (one per title character)
-- @return table
local function _build_section_title(title, title_gap, underline_char)
	local title_struct = {}

	if title ~= "" then
		table.insert(title_struct, title)
		if underline_char ~= "" then table.insert(title_struct, string.rep(underline_char, #title)) end
	end

	if title_gap then table.insert(title_struct, "") end
	return title_struct
end

local function _join_strings(a, b)
	if a == "" then return b end
	if b == "" then return a end
	return a .. " " .. b
end

local function _join_or(val_1, val_2, fallback)
	if val_1 == "" and val_2 == "" then return fallback end
	return _join_strings(val_1, val_2)
end

--- Formats a single item line according to the given style options
-- @param style table Configuration options for the current section
-- @param wrapped_name string Item name already wrapped with its delimiters
-- @param wrapped_type string Item type already wrapped with its delimiters
-- @return string|table item_line_content If `style.inline` is true, returns a single formatted line.
-- Otherwise, returns a two-element array of formatted lines.
local function _format_item(style, wrapped_name, wrapped_type)
	local inline = style[opts.inline.val]

	local item_type_kw = style[opts.type_kw.val]
	local type_with_kw = _join_strings(item_type_kw, wrapped_type)

	local type_content
	if inline then
		type_content = type_with_kw
	else
		local name_with_type_kw = _join_or(item_type_kw, wrapped_name, type_with_kw)
		local type_with_name = _join_or(name_with_type_kw, wrapped_type, wrapped_name)
		type_content = style[opts.is_type_below_name_first.val] and type_with_name or type_with_kw
	end

	local name_content = _join_strings(style[opts.name_kw.val], wrapped_name)

	local first, second
	if style[opts.type_first.val] then
		first, second = type_content, name_content
	else
		first, second = name_content, type_content
	end

	local indent = style[opts.indent.val] and "\t" or ""

	if not inline then return {
		indent .. first,
		indent .. second,
	} end

	return indent .. _join_strings(first, second)
end

--- Wraps the item name and type using their respective wrapper pairs
-- @param item table Item data containing `name` and `type`
-- @param include_type boolean Whether to include and wrap the item type
-- @param name_wrapper table Two-element table used to wrap the item name
-- @param type_wrapper table Two-element table used to wrap the item type
-- @return string Wrapped item name
-- @return string Wrapped item type
local function _wrap_item_data(item, include_type, name_wrapper, type_wrapper)
	local name_wrapper_copy, type_wrapper_copy = { unpack(name_wrapper) }, { unpack(type_wrapper) }

	table.insert(name_wrapper_copy, 2, item.name or "")
	table.insert(type_wrapper_copy, 2, include_type and item.type or "")

	return table.concat(name_wrapper_copy, ""), table.concat(type_wrapper_copy, "")
end

--- Builds the raw annotation content for each section, without applying the final structure
-- Iterates through the sections in the configured order, formats each item according to
-- its section style, and groups the resulting lines by section name
-- @param item_data table Mapping of section names to item lists
-- @param style table Style configuration for all sections and general options
-- @return table Table mapping section names to their formatted content lines
local function _build_annotation_content(item_data, style)
	local annotation_content = {}

	for _, section_name in ipairs(style.general[opts.section_order.val]) do
		local section_items = item_data[section_name]
		local section_style = style[section_name]

		local section_content = {
			unpack(
				_build_section_title(
					section_style[opts.title.val],
					style.general[opts.section_title_gap.val],
					style.general[opts.section_underline.val]
				)
			),
		}
		for _, item in ipairs(section_items) do
			local include_type = (item.type and style[opts.include_type.val])
			local wrapped_name, wrapped_type = _wrap_item_data(
				item,
				include_type,
				section_style[opts.name_wrapper.val],
				section_style[opts.type_wrapper.val]
			)

			local item_line_content = _format_item(section_style, wrapped_name, wrapped_type)
			local is_item_line_content_multiline = type(item_line_content) == "table"

			if is_item_line_content_multiline then
				for _, val in ipairs(item_line_content) do
					table.insert(section_content, val)
				end
			else
				table.insert(section_content, item_line_content)
			end
		end

		annotation_content[section_name] = section_content
	end
	return annotation_content
end

--- Formats the annotation content into the final annotation structure
-- @param sections_data table Section-formatted annotation content
-- @param style table Style configuration for all sections and general options
-- @param annotation_structure table Base annotation structure to populate
-- @return table Final formatted annotation as a flat list of lines
local function _format_annotation_content(sections_data, style, annotation_structure)
	local general_opts = style.general
	local line_start = style.general[opts.struct.val][2]

	local annotation_structure_copy = vim.deepcopy(annotation_structure)

	if general_opts[opts.title_gap.val] then
		local title_gap_pos = general_opts[opts.title_pos.val] + 1
		table.insert(annotation_structure_copy, title_gap_pos, line_start)
	end

	local sections_order = general_opts[opts.section_order.val]
	for section_idx, section_name in ipairs(sections_order) do
		local section_content = sections_data[section_name]

		for line_idx, line in ipairs(section_content) do
			table.insert(annotation_structure_copy, #annotation_structure_copy, line_start .. line)

			if general_opts[opts.item_gap.val] and section_content[line_idx + 1] then
				table.insert(annotation_structure_copy, #annotation_structure_copy, line_start)
			end
		end

		if general_opts[opts.section_gap.val] and sections_order[section_idx + 1] then
			table.insert(annotation_structure_copy, #annotation_structure_copy, line_start)
		end
	end

	-- Elements are inserted at the index of the last element, shifting that element to the right. As a result,
	-- the original last element of the base annotation structure ends up at the very end of the final annotation.
	-- This is desired when the base structure has three parts, but becomes a leftover element when it has only two
	if #annotation_structure == 2 then table.remove(annotation_structure_copy, #annotation_structure_copy) end

	return annotation_structure_copy
end

return function(style, data, annotation_structure)
	local annotation_content = _build_annotation_content(data, style)
	Debug_logger.log("Annotation content:", annotation_content)

	return _format_annotation_content(annotation_content, style, annotation_structure)
end
