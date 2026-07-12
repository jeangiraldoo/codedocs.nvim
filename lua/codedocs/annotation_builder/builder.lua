local Annot_builder = {}
Annot_builder.__index = Annot_builder

function Annot_builder.new(items, builder_config, row)
	local obj = {
		placeholders = {
			general = {},
			items = {},
		},
		state = {
			lines = {},
			snip_idx_counter = 1,
		},
		items = items,
		line_indent = (function()
			local cols = vim.fn.indent(row + 1)
			if cols == -1 then return "" end

			if vim.bo.expandtab then return string.rep(" ", cols) end

			local tabstop = vim.bo.tabstop
			local tabs = math.floor(cols / tabstop)
			local spaces = cols % tabstop

			return string.rep("\t", tabs) .. string.rep(" ", spaces)
		end)(),
	}
	obj = vim.tbl_deep_extend("force", obj, vim.deepcopy(builder_config))

	setmetatable(obj, Annot_builder)
	return obj
end

function Annot_builder:apply_general_placeholder(str)
	for placeholder, handler in pairs(self.placeholders.general) do
		str = str:gsub(placeholder, function() return handler(self.state) end)
	end

	return str
end

function Annot_builder:apply_item_placeholder(str, item)
	for placeholder, handler in pairs(self.placeholders.items) do
		str = str:gsub(placeholder, function() return handler(self.state, item) end)
		str = self:apply_general_placeholder(str)
	end

	return str
end

function Annot_builder:build_items_group_lines(group_items, layout, gap)
	if #group_items == 0 then return {} end

	local group_lines = {}

	for idx, item in ipairs(group_items) do
		for _, layout_line in ipairs(layout) do
			table.insert(group_lines, self:apply_item_placeholder(layout_line, item))

			if idx < #group_items and gap and gap.enabled then
				table.insert(group_lines, self:apply_general_placeholder(gap.text))
			end
		end
	end

	return group_lines
end

function Annot_builder:block(blocks, is_item)
	local content = {}

	local gap_data
	for _, block in ipairs(blocks) do
		local block_lines = {}
		if is_item then
			local block_items = self.items[block.name]
			if block_items then
				block_lines = self:build_items_group_lines(block_items, block.layout, block.insert_gap_between)
			end
		elseif block.items and not vim.tbl_isempty(block.items) then
			block_lines = {}
			local items_lines = self:block(block.items, true)

			-- emit this block's own layout
			if not vim.tbl_isempty(items_lines) then
				for _, ln in ipairs(block.layout or {}) do
					table.insert(block_lines, self:apply_general_placeholder(ln))
				end
				vim.list_extend(block_lines, items_lines)
			end
		else
			for _, ln in ipairs(block.layout) do
				table.insert(block_lines, self:apply_general_placeholder(ln))
			end
		end

		if
			-- idx < #blocks
			#block_lines > 0
			and gap_data
			and gap_data[block.name]
			and gap_data[block.name].enabled
		then
			table.insert(content, gap_data[block.name].text)
		end

		vim.list_extend(content, block_lines)

		if #block_lines > 0 then gap_data = block.gap_before end
	end

	if vim.tbl_isempty(content) then return {} end

	return content
end

function Annot_builder:build(blocks)
	local block_lines = self:block(blocks, false)

	vim.list_extend(self.state.lines, block_lines)

	return self.state.lines
end

return Annot_builder
