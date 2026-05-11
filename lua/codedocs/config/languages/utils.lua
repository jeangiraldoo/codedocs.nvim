local Utils = {}

local COMMON_SECTION_OPTS = {
	layout = {},
	insert_gap_between = {
		enabled = false,
		text = "",
	},
}

local NON_ITEM_BASED_SECTION_DEFAULTS = vim.tbl_deep_extend("force", vim.deepcopy(COMMON_SECTION_OPTS), {
	name = "",
	ignore_prev_gap = false,
})

function Utils.new_blocks_list(blocks_list)
	vim.validate {
		blocks_list = { blocks_list, "table" },
	}

	local final_list = {}
	for _, block in ipairs(blocks_list) do
		local new_block_opts = vim.tbl_deep_extend("force", vim.deepcopy(NON_ITEM_BASED_SECTION_DEFAULTS), block)

		if new_block_opts.items then
			new_block_opts.items = vim.tbl_deep_extend("force", vim.deepcopy(COMMON_SECTION_OPTS), new_block_opts.items)
		end

		table.insert(final_list, new_block_opts)
	end

	return final_list
end

return Utils
