local Utils = {}

local DEFAULT_OPTS = {
	block = {
		name = "",
		layout = {},
		insert_gap_between = {
			before = {},
			text = "",
		},
	},
	items = {
		layout = {},
		insert_gap_between = {
			text = "",
			enabled = false,
		},
	},
}

function Utils.new_blocks_list(blocks_list)
	vim.validate {
		blocks_list = { blocks_list, "table" },
	}

	local final_list = {}
	for _, block in ipairs(blocks_list) do
		local new_block_opts = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULT_OPTS.block), block)

		if new_block_opts.items then
			new_block_opts.items = vim.tbl_deep_extend("force", vim.deepcopy(DEFAULT_OPTS.items), new_block_opts.items)
		end

		table.insert(final_list, new_block_opts)
	end

	return final_list
end

return Utils
