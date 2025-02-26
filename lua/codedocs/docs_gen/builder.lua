local opts

local function get_sect_title(general_style, style, ln_start)
	local title_struct = {}
	local title = style[opts.title.val]
	local gap = general_style[opts.section_title_gap.val]
	local underline_char = general_style[opts.section_underline.val]

	local final_title = ln_start .. title
	if title ~= "" then table.insert(title_struct, final_title) end

	if underline_char ~= "" then table.insert(title_struct, ln_start .. string.rep(underline_char, #title)) end

	if gap then table.insert(title_struct, ln_start .. "") end
	return title_struct
end

local function get_final_docs(style, sects, docs)
	local title_gap = style.general[opts.title_gap.val]
	local title_pos = style.general[opts.title_pos.val]
	local ln_start = style.general[opts.struct.val][2]

	-- Extend the first table with the second one, starting at its penultimate position
	table.insert(docs, #docs, sects)
	local new_docs = vim.iter(docs):flatten():totable()

	if #sects > 0 and title_gap then table.insert(new_docs, title_pos, ln_start) end
	if #style.general[opts.struct.val] == 2 then table.remove(new_docs, #new_docs) end
	return new_docs
end

--- Returns a string formatted by separating both strings with a space
-- @param val_1 string The first string
-- @param val_2 string The second string
-- @return string The formatted string
local function get_formatted_full_vals(val_1, val_2) return val_1 .. " " .. val_2 end

--- Returns the non-empty string when one is empty
-- or a default value if both are empty
-- @param val_1 string The first string
-- @param val_2 string The second string
-- @param default_val string The value returned when both strings are empty
-- @return string The non-empty string or the default value
local function get_formatted_empty_vals(val_1, val_2, default_val)
	local final_val
	if val_1 == "" and val_2 == "" then
		final_val = default_val
	elseif val_1 == "" then
		final_val = val_2
	elseif val_2 == "" then
		final_val = val_1
	end
	return final_val
end

--- Formats 2 strings based on wether at least one is empty
-- @param val_1 The string for the beggining
-- @param val_2 The string for the end
-- @param default_val string The value used when both strings are empty
-- @return string A formatted string combining the 2 values
local function get_formatted_vals(val_1, val_2, default_val)
	local one_empty_val = val_1 == "" or val_2 == ""
	local formatted_vals = one_empty_val and get_formatted_empty_vals(val_1, val_2, default_val)
		or get_formatted_full_vals(val_1, val_2)
	return formatted_vals
end

--- Formats an item in 1 line
-- @param part_1 string Formatted data for the line's beginning
-- @param part_2 string Formatted data for the line's end
-- @param base_ln string String used at the beginning of a line
-- @return string An item formatted in 1 line
local function get_inline_ln(part_1, part_2, base_ln)
	local formatted_item = get_formatted_vals(part_1, part_2, "")
	return base_ln .. formatted_item
end

--- Formats an item across 2 lines
-- @param part_1 string Formatted data for the line's beginning
-- @param part_2 string Formatted data for the line's end
-- @param base_ln string String used at the beginning of a line
-- @return table An item formatted across 2 lines
local function get_split_ln(part_1, part_2, base_ln)
	local item_ln = { base_ln .. part_1, base_ln .. part_2 }
	return item_ln
end

--- Returns a formatted item line
-- @param general_style table Options for the full docstring
-- @param style table Configuration options for the section
-- @param handler function Formats the item data
-- @param part_1 string Formatted data for the line's beginning
-- @param part_2 string Formatted data for the line's end
-- @return string|table A formatted line
local function item_ln_factory(general_style, style, handler, part_1, part_2)
	local ln_start = general_style[opts.struct.val][2]
	local base_ln = style[opts.indent.val] and ("\t" .. ln_start) or ln_start
	local res = handler(part_1, part_2, base_ln)
	return res
end

local function get_item_ln(general_style, style, wrapped_item)
	local item_name, item_type = unpack(wrapped_item)
	local item_kw, item_type_kw = style[opts.name_kw.val], style[opts.type_kw.val]

	local is_inline = style[opts.inline.val]
	local is_type_first = style[opts.type_first.val]

	local name_with_kw = get_formatted_vals(item_kw, item_name, "")
	local type_with_kw = get_formatted_vals(item_type_kw, item_type, "")

	local formatted_type, handler
	if is_inline then
		handler = get_inline_ln
		formatted_type = type_with_kw
	else
		local is_type_below_name_first = style[opts.is_type_below_name_first.val]
		local name_with_type_kw = get_formatted_vals(item_type_kw, item_name, type_with_kw)
		local type_with_name = get_formatted_vals(name_with_type_kw, item_type, item_name)
		formatted_type = is_type_below_name_first and type_with_name or type_with_kw
		handler = get_split_ln
	end
	local order = is_type_first and { formatted_type, name_with_kw } or { name_with_kw, formatted_type }
	local res = item_ln_factory(general_style, style, handler, unpack(order))
	return res
end

--- Wraps the item name and type with their respective wrappers
-- @param style table Configuration options for a specific section
-- @param item table Item data (name and type) to wrap
-- @return table The wrapped item name and type
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

local function get_sect_body(general_style, style, items)
	local ln_start = general_style[opts.struct.val][2]
	local base_ln = style[opts.indent.val] and ("\t" .. ln_start) or ln_start
	local body = vim.iter(items)
		:enumerate()
		:map(function(idx, item)
			local insert_gap = general_style[opts.item_gap.val] and idx < #items
			local wrapped_item = get_wrapped_item(style, item)
			local item_ln = get_item_ln(general_style, style, wrapped_item)
			if type(item_ln) == "string" then
				return insert_gap and { item_ln, base_ln } or item_ln
			elseif insert_gap then
				table.insert(item_ln, base_ln)
			end
			return item_ln
		end)
		:flatten()
		:totable()
	return body
end

--- Returns a fully built docstring section
-- @param general_style table Configuration options that apply to the entire docstring
-- @param style table Configuration options for a specific section
-- @param items table Item data for the specific section
-- @return table A fully built docstring section
local function get_sect(general_style, style, items)
	local ln_start = general_style[opts.struct.val][2]
	local body = get_sect_body(general_style, style, items)
	if #body == 0 then return body end

	local title = get_sect_title(general_style, style, ln_start)
	return vim.list_extend(title, body)
end

local function get_docs_body(style, sects_items)
	local general_style = style.general
	local ln_start = general_style[opts.struct.val][2]
	local sect_order = general_style[opts.section_order.val]
	local sects = vim.iter(sect_order)
		:enumerate()
		:map(function(idx, name)
			local sect_style, sect_items = style[name], sects_items[name]
			local sec = get_sect(general_style, sect_style, sect_items)
			if #sec == 0 then return end

			local next_sect = sect_order[idx + 1]
			local has_gap = (
				general_style[opts.section_gap.val]
				and next_sect
				and vim.tbl_count(sects_items[next_sect])
			)
			if has_gap then table.insert(sec, ln_start) end
			return sec
		end)
		:flatten()
		:totable()
	return sects
end

--- Returns a fully built docstring
-- @param options table Enum used to access values from style
-- @param style table Configuration options for the docstring
-- @param data table Item data for every docstring section
-- @param docs_struct table Docstring base template
-- @return table A complete docstring
local function get_docs(options, style, data, docs_struct)
	opts = options
	local docs_lns = get_docs_body(style, data)
	local final_docs = get_final_docs(style, docs_lns, vim.deepcopy(docs_struct))
	return final_docs
end

return {
	get_docs = get_docs,
}
