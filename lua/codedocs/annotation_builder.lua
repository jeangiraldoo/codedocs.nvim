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

function Annotation.new(indented, line_num)
	local new_annotation = {
		_lines = {},
		_snippet_tabstop_idx_counter = 1,
		line_num = line_num,
		should_indent = indented,
	}

	return setmetatable(new_annotation, { __index = Annotation })
end

function Annotation:get_lines() return self._lines end

function Annotation:extend(tbl)
	for _, line in ipairs(tbl) do
		self.insert(self, line)
	end
end

function Annotation:new_block(block_opts, block_items)
	self:extend(block_opts.layout)

	if not block_items then return end
	for item_idx, item in ipairs(block_items) do
		for _, line in ipairs(block_opts.items.layout) do
			self:insert(line, item)

			local is_last_item = block_items[item_idx + 1] == nil
			if block_opts.items.insert_gap_between.enabled and not is_last_item then
				self:insert(block_opts.items.insert_gap_between.text, item)
			end
		end
	end
end

function Annotation:insert(line, item)
	if line == "" then
		table.insert(self._lines, line)
		return
	end

	local line_indent = (function()
		local line_row = self.line_num
		local cols = vim.fn.indent(line_row)
		if cols == -1 then return "" end

		if vim.bo.expandtab then return string.rep(" ", cols) end

		local tabstop = vim.bo.tabstop
		local tabs = math.floor(cols / tabstop)
		local spaces = cols % tabstop

		return string.rep("\t", tabs) .. string.rep(" ", spaces)
	end)()

	line = line_indent .. line

	if self.should_indent then line = compute_neovim_indentation() .. line end

	local placeholders = item and self.item_placeholder or self.placeholders

	for placeholder, handler in pairs(placeholders) do
		line = line:gsub(placeholder, function() return handler(self, item) end)
	end

	table.insert(self._lines, line)
end

function Annotation:insert_blocks(blocks, items)
	local insert_gap = false
	local last_created_block_idx = 1
	for block_idx, block in ipairs(blocks) do
		local is_item_based_block = type(block.items) == "table"

		local block_items = items[block.name]

		local at_least_one_block_item = block_items and #block_items > 0 and #block.items.layout > 0
		if not is_item_based_block or at_least_one_block_item then
			if block_idx > 1 and insert_gap and not block.ignore_prev_gap then
				self:insert(blocks[last_created_block_idx].insert_gap_between.text)
				insert_gap = false
			end
			self:new_block(block, block_items)
		end

		insert_gap = insert_gap or block.insert_gap_between.enabled
		if block.insert_gap_between.enabled then
			insert_gap = block.insert_gap_between.enabled
			last_created_block_idx = block_idx
		end
	end
end

return Annotation
