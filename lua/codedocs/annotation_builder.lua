local Annotation = {
	placeholders = {
		general = {},
		items = {},
	},
}

function Annotation.new(line_num, opts)
	local new_annotation = {
		line_num = line_num,
	}

	new_annotation = vim.tbl_deep_extend("force", new_annotation, vim.deepcopy(opts))

	---@deprecated
	new_annotation.placeholders.general["%%snippet_tabstop_idx"] = function(self, _, _)
		vim.notify_once("%snippet_tabstop_idx is deprecated; use %snip_idx instead", vim.log.levels.WARN)
		return new_annotation.placeholders.general["%%snip_idx"](self.state)
	end
	new_annotation.placeholders.items = vim.tbl_deep_extend(
		"force",
		new_annotation.placeholders.items,
		vim.deepcopy(new_annotation.placeholders.general)
	)

	return setmetatable(new_annotation, { __index = Annotation })
end

function Annotation:get_lines() return self.state.lines end

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
		table.insert(self.state.lines, line)
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

	local placeholders = item and self.placeholders.items or self.placeholders.general

	for placeholder, handler in pairs(placeholders) do
		line = line:gsub(placeholder, function() return handler(self.state, item) end)
	end

	table.insert(self.state.lines, line)
end

function Annotation:insert_blocks(blocks, items)
	local gap_data

	for _, block in ipairs(blocks) do
		local is_item_based_block = type(block.items) == "table"

		local block_items = items[block.name]

		local at_least_one_block_item = block_items and #block_items > 0 and #block.items.layout > 0
		if not is_item_based_block or at_least_one_block_item then
			if gap_data and gap_data[block.name] and gap_data[block.name].enabled then
				self:insert(gap_data[block.name].text)
			end
			self:new_block(block, block_items)
			gap_data = block.gap_before
		end
	end
end

return Annotation
