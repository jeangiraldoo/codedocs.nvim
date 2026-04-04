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

---@param section_data {
---    name: string?,
---    layout: string[]?,
---    insert_gap_between: {
---        enabled: boolean?,
---        text: string? }? } Section options
---@param items_data ({
---    layout: string[]?,
---    insert_gap_between: {
---        enabled: boolean?,
---        text: string? } })? Item options
---@return {
---    name: "" | string,
---    layout: string[],
---    insert_gap_between: {
---        enabled: boolean,
---        text: "" | string },
---    ignore_prev_gap: boolean,
---    items: {
---        layout: string[],
---        insert_gap_between: {
---            enabled: boolean,
---            text: "" | string }}?} Section
function Utils.new_section(section_data, items_data)
	assert(
		type(section_data) == "table",
		"The `section_data` parameter must be a table, received " .. type(section_data)
	)
	if items_data then
		assert(
			type(items_data) == "table",
			"The `section_data` parameter must be a table, received " .. type(items_data)
		)
	end
	local section_opts = vim.tbl_deep_extend("force", vim.deepcopy(NON_ITEM_BASED_SECTION_DEFAULTS), section_data)
	if items_data then
		section_opts.items = vim.tbl_deep_extend("force", vim.deepcopy(COMMON_SECTION_OPTS), items_data)
	end
	return section_opts
end

return Utils
