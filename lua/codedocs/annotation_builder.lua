local Debug_logger = require "codedocs.utils.debug_logger"

local function compute_neovim_indentation()
	if not vim.bo.expandtab then return "\t" end

	local shiftwidth = vim.bo.shiftwidth
	if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end
	return string.rep(" ", shiftwidth)
end

local Annotation = {
	placeholders = {
		["%%>"] = function(_, _, _) return compute_neovim_indentation() end,
		["%%snippet_tabstop_idx"] = function(self, _, _)
			local snippet_tabstop_idx_label = tostring(self._snippet_tabstop_idx_counter)

			self._snippet_tabstop_idx_counter = self._snippet_tabstop_idx_counter + 1

			return snippet_tabstop_idx_label
		end,
	},
}

Annotation.item_placeholder = vim.tbl_deep_extend("force", vim.deepcopy(Annotation.placeholders), {
	["%%item_name"] = function(_, item) return item.name end,
	["%%item_type"] = function(_, item) return item.type end,
})

function Annotation.new()
	local new_annotation = {
		_lines = {},
		_snippet_tabstop_idx_counter = 1,
	}

	return setmetatable(new_annotation, { __index = Annotation })
end

function Annotation:get_lines() return self._lines end

function Annotation:extend(tbl, target_data)
	for _, line in ipairs(tbl) do
		self.insert(self, line, target_data)
	end
end

function Annotation:insert(line, target_data, item)
	if line == "" then
		table.insert(self._lines, line)
		return
	end

	if target_data then
		local line_indent = (function()
			local line_row = target_data.line_num
			local cols = vim.fn.indent(line_row)
			if cols == -1 then return "" end

			if vim.bo.expandtab then return string.rep(" ", cols) end

			local tabstop = vim.bo.tabstop
			local tabs = math.floor(cols / tabstop)
			local spaces = cols % tabstop

			return string.rep("\t", tabs) .. string.rep(" ", spaces)
		end)()

		line = line_indent .. line

		if target_data.should_indent then line = compute_neovim_indentation() .. line end
	end

	local placeholders = item and self.item_placeholder or self.placeholders

	for placeholder, handler in pairs(placeholders) do
		line = line:gsub(placeholder, function() return handler(self, item) end)
	end

	table.insert(self._lines, line)
end

local function _should_insert_gap_between_blocks(block_idx, style, block_style, item_data)
	local current_block_is_last = block_idx == #style.blocks
	if current_block_is_last then return false end

	local next_block = style.blocks[block_idx + 1]
	local next_block_is_item_based = next_block and type(next_block.items) == "table"
	if not next_block_is_item_based then
		return block_style.insert_gap_between.enabled and not next_block.ignore_prev_gap
	end

	local next_block_has_items = item_data[next_block.name] and #item_data[next_block.name] > 0

	if not next_block_has_items then return false end

	if #next_block.layout == 0 and #next_block.items.layout == 0 then return false end

	return block_style.insert_gap_between.enabled and not next_block.ignore_prev_gap
end

--- Builds the raw annotation content for each block, without applying the final structure
--- Iterates through the blocks in the configured order, formats each item according to
--- its block style, and groups the resulting lines by block name
--- @param item_data table Mapping of block names to item lists
--- @param style table Style configuration for all blocks and settings options
--- @return table Table mapping block names to their formatted content lines
return function(style, item_data, target_data)
	assert(type(item_data) == "table", "'item_data' must be a table, got " .. type(item_data))
	assert(type(style) == "table", "'style' must be a table, got " .. type(style))

	local annotation = Annotation.new()

	for block_idx, block_style in ipairs(style.blocks) do
		local is_item_based_block = type(block_style.items) == "table"

		if not is_item_based_block then annotation:extend(block_style.layout, target_data) end

		local block_items = item_data[block_style.name]

		local at_least_one_block_item = block_items and #block_items > 0
		if not is_item_based_block or not at_least_one_block_item then goto skip_item_styling end

		annotation:extend(block_style.layout, target_data)

		for item_idx, item in ipairs(block_items) do
			for _, line in ipairs(block_style.items.layout) do
				annotation:insert(line, target_data, item)

				local is_last_item = block_items[item_idx + 1] == nil
				if block_style.items.insert_gap_between.enabled and not is_last_item then
					annotation:insert(block_style.items.insert_gap_between.text, target_data, item)
				end
			end
		end

		::skip_item_styling::

		if _should_insert_gap_between_blocks(block_idx, style, block_style, item_data) then
			annotation:insert(block_style.insert_gap_between.text, target_data)
		end
	end

	local annotation_lines = annotation:get_lines()

	Debug_logger.log("Annotation content", annotation_lines)

	return annotation_lines
end
